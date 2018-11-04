{   subroutine math_simul (N, MATRIX, ANSWER, VALID)
*
*   Solve a set of simultaneous linear equations.  N is the number of equations
*   (and therefore variables to solve for).  MATRIX is a 2 dimensional array
*   that must be dimensioned [1..N,1..N+1].  The first subscript indicates
*   which equation.  The second subscript indicates which coeficient inside
*   the particular equation.  The first N coeficients in an equation are the
*   coeficients for each of the variables.  The last value is the constant term.
*   The form for a set of 2 equations is shown below.  The values in parenthesis
*   are the MATRIX subscript numbers.
*
*     (1,1)a + (1,2)b = (1,3)
*     (2,1)a + (2,2)b = (2,3)
*
*   Answer is a one dimensional array dimensioned [1..N].  The value of the
*   variables will be returned in ANSWER in the order they appear in MATRIX.
*   for the example above:
*
*     ANSWER[1] = a
*     ANSWER[2] = b
*
*   VALID is a logical variable that is set to TRUE if the equations were
*   really linearly independent and N was within range.  Otherwise VALID is
*   set to FALSE, and ANSWER is not altered.
*
*   The solution if formed by successive reduction of the NxN part of the
*   matrix to an identity.  In this form, the N+1 column becomes the answer
*   array.
}
module math_simul;
define math_simul;
%include '/cognivision_links/dsee_libs/math/math2.ins.pas';

procedure math_simul (                 {solve simultaneous equations}
  in      n: sys_int_machine_t;        {number of equations}
  var     user_matrix: univ math_real_ar_arg_t; {the equations}
  out     answer: univ math_real_ar_arg_t; {answer array}
  out     valid: boolean);             {true if could find answer}
  val_param;

const
  max_n = 10;                          {max N size allowed}
  error_limit = 1.0e-20;               {non-zero limit for VALID determination}
  matrix_size = max_n*(max_n+1);       {size of internal matrix}

var
  matrix: array[1..matrix_size] of double; {internal double precision array}
  row_index: array[1..max_n] of sys_int_machine_t; {MATRIX indices for start of rows}
  i: sys_int_machine_t;                {loop counter and scratch sys_int_machine_t}
  n1: sys_int_machine_t;               {number of equations + 1}
  piv: sys_int_machine_t;              {number of the pivot row}
  row: sys_int_machine_t;              {current row number in matrix}
  m: double;                           {scratch multiplier value}
  r: double;                           {scratch floating point value}
  piv_ind: sys_int_machine_t;          {MATRIX index to start of pivot row}
  p_ind: sys_int_machine_t;            {MATRIX index into pivot row}
  ind: sys_int_machine_t;              {MATRIX index}

begin
  valid := false;                      {init to no unique solution exists}
{
*   First make a local double precision copy of the user's matrix.  Then
*   initialize the ROW_INDEX array so that it points to the start of that
*   row in MATRIX.
}
  if (n < 1) or (n > max_n) then return; {number of equations out of range ?}
  n1 := n + 1;                         {number of columns in full matrix}
  for i := 1 to (n * n1) do            {scan all elements in matrix}
    matrix[i] := user_matrix[i];       {make local double precision copy}
  i := 1;                              {init to first row index}
  for row := 1 to n do begin           {once for each entry in ROW_INDEX}
    row_index[row] := i;               {init index for this row}
    i := i + n1;                       {make index for next row}
    end;                               {back for next row}
{
*   MATRIX, ROW_INDEX, and N1 are all set up.  Now loop thru the matrix
*   making each row in turn the pivot row.  This means we will
*   end up with a 1 for the diagonal element in the pivot row, and zeros in
*   the rest of that column.  The pivot row is chosen out of the remaining
*   rows that have not yet been pivot rows by which has the largest magnitude
*   value in the column of interest.  If this is ever zero, then INVALID is
*   set, and the subroutine is aborted.  The indices in ROW_INDEX are swapped
*   so that the pivot rows end up in order.  The final result will be the
*   identity matrix.  The identity values are never actually written back
*   into MATRIX, because there is no need to ever read them back out.
}
  for piv := 1 to n do begin           {loop thru each row as pivot row}
    m := error_limit;                  {init largest found so far}
    i := 0;                            {init largest found to none found}
    for row := piv to n do begin       {scan remaining rows}
      r := abs(matrix[row_index[row] + piv - 1]); {magnitude at this row}
      if r > m then begin              {bigger than best found so far ?}
        m := r;                        {update largest magnitude so far}
        i := row;                      {update best row number so far}
        end;
      end;                             {back for next row to check}
    if i = 0 then return;              {no non-zero element in column ?}
    piv_ind := row_index[i];           {set index to this pivot row,}
    row_index[i] := row_index[piv];    {and swap pivot row into place}
    row_index[piv] := piv_ind;
{
*   The new pivot row has been identified and swapped into place
*   in the ROW_INDEX array.  PIV_IND is set to the starting MATRIX
*   subscript of the pivot row.  Now divide the pivot row
*   by its element in the diagonal.  This puts one more 1 in the
*   diagonal.
}
    p_ind := piv_ind + piv - 1;        {index to diagonal pivot element}
    m := 1.0 / matrix[p_ind];          {make mult factor for rest of row}
    for i := 1 to n1 - piv do begin    {scan rest of pivot row to right}
      p_ind := p_ind + 1;              {point to next element in pivot row}
      matrix[p_ind] := matrix[p_ind] * m; {normalize this element}
      end;                             {back for next pivot row element}
{
*   The pivot row has been normalized so that its diagonal element is
*   set to 1.  Now loop thru all the non-pivot rows and set their pivot
*   column elements to 0.  This is done by subtracting out a multiple
*   of the pivot row from the row in question.
}
    for row := 1 to n do begin         {scan thru all the rows}
      if row = piv then next;          {avoid the pivot row}
      ind := row_index[row] + piv - 1; {this row index at pivot column}
      m := matrix[ind];                {this row element at pivot column}
      for p_ind := (piv_ind + piv) to (piv_ind + n) do begin {scan rest piv row}
        ind := ind + 1;                {advance to new row element}
        matrix[ind] := matrix[ind] - (m * matrix[p_ind]); {subtract mult of piv}
        end;                           {back for next element accross}
      end;                             {back for next non_pivot row}
    end;                               {back for next pivot row}
{
*   The NxN part of the matrix set to the identity.  Note that these
*   values have not actually been written, but that we also never
*   tried to read them back.  This leaves the answers in the constant
*   vector.  Now copy the constant vector into the answer array.
}
  for i := 1 to n do                   {once for each variable}
    answer[i] := matrix[row_index[i] + n]; {copy constant column}
  valid := true;                       {there really was an answer}
  end;
