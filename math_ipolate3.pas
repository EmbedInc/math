{   Function MATH_IPOLATE3 (TABLE, N, X)
*
*   Cubically interpolate the table values at X to find the resulting Y.
*   N is the number of entries in TABLE.  The resulting interpolated values
*   will have second order continuity.  The table values must be arranged
*   in ascending X order, and no two table entries may have the same X value.
}
module math_ipolate3;
define math_ipolate3;
%include 'math2.ins.pas';

function math_ipolate3 (               {cubically interpolate into table of values}
  in      table: univ math_funar_arg_t; {pairs of XY values}
  in      n: sys_int_machine_t;        {number of XY pairs in TABLE array}
  in      x: real)                     {input value where to evaluate table at}
  :double;                             {interpolated Y value from table}
  val_param;

var
  l: sys_int_machine_t;                {table index for last entry below X}
  h: sys_int_machine_t;                {table index for first entry above X}
  t: double;                           {normalized 0-1 over interval for X}
  ts: double;                          {scale factor to go from T to X}
  dl, dh: double;                      {normalized derivatives at L and H}
  dy: double;                          {delta Y over interval}
  i: sys_int_machine_t;                {scratch integer}
  a, b, c, d: double;                  {cubic equation coeficients}

label
  got_interval;
{
****************
*
*   Local function DERIVATIVE (TABLE, N, IND)
*
*   Return the derivative of the table function at control point IND.  N is
*   the number of entries in TABLE, which must be at least 2.
}
function derivative (                  {get derivative at control point}
  in      table: univ math_funar_arg_t; {pairs of XY values}
  in      n: sys_int_machine_t;        {number of XY pairs in TABLE array}
  in      ind: sys_int_machine_t)      {1-N control point ind to make derivative at}
  :double;                             {returned derivative}
  val_param;

var
  dx1: double;                         {delta X over preceeding interval}
  dx2: double;                         {delta X over succeeding interval}
  sl1, sl2: double;                    {slopes over prec and succ intervals}
  m: double;                           {weighting fraction for preceeding interval}

begin
  if ind = 1 then begin                {at first point in table ?}
    derivative := (table[2].y - table[1].y) / (table[2].x - table[1].x);
    return;
    end;
  if ind = n then begin                {at last point in table ?}
    derivative := (table[n].y - table[n-1].y) / (table[n].x - table[n-1].x);
    return;
    end;
{
*   The point is an "interior" table entry.  The derivative of the point
*   will be a blend of the derivatives of the preceeding and succeeding
*   intervals.
}
  dx1 := table[ind].x - table[ind-1].x; {DX over preceeding interval}
  dx2 := table[ind+1].x - table[ind].x; {DX over succeeding interval}
  sl1 := (table[ind].y - table[ind-1].y) / dx1; {slope for preceeding interval}
  sl2 := (table[ind+1].y - table[ind].y) / dx2; {slope for succeeding interval}
  m := dx2 / (dx1 + dx2);              {make weighting fraction for prec interval}
  derivative :=                        {make final derivative and pass back}
    m * sl1 + (1.0 - m) * sl2;         {linearly blend the prec/succ slopes}
  end;
{
****************
*
*   Start of main routine.
}
begin
  if n <= 0 then begin                 {table is empty}
    math_ipolate3:= 0.0;               {return arbitrary value}
    return;
    end;
  if n = 1 then begin                  {table contains only a single value ?}
    math_ipolate3 := table[0].y;       {return the only existing value}
    return;
    end;
{
*   The table contains at least two values.
*
*   Do a binary search on the table entries to find the last entry below
*   X.  L and H will be set to the adjacent table indicies surrounding
*   the value.
}
  l := 1;                              {init interval to whole table}
  h := n;

  if x < table[1].x then begin         {below first entry ?}
    h := 2;                            {use first interval}
    goto got_interval;
    end;
  if x >= table[h].x then begin        {above last entry ?}
    l := h - 1;                        {use last interval}
    goto got_interval;
    end;

  while h > (l + 1) do begin           {loop until no control points within interval}
    i := (l + h) div 2;                {make center interval index}
    if table[i].x <= x                 {decide which end point to move to center}
      then l := i
      else h := i;
    end;                               {back and check out new interval}
{
*   The interval from L to H will be used as the basis for interpolation.
*   L and H are sequential TABLE indicies.  X will be within the interval
*   unless X was outside the table range.
*
*   The interpolation will be performed by fitting a cubic polynomial to
*   the interval.  To simplify the coeficients, the polynomial will be
*   a function of T, the normalized X value that varies from 0 to 1 over
*   the interval.  The general equation is therfore:
*
*     Y = (T**3)A + (T**2)B + (T)C + D
*
*   and its derivative is:
*
*     dY/dT = (3 * T**2)A + (2T)B + C
*
*   4 equations are required to determine the coeficients A-D.  The first
*   two equations come from the constraints that the equation must produce
*   the correct value at the two interval points, F(0) = Y0, F(1) = Y1.
*   The last two equations constrain the derivatives at the control points,
*   dF(0)/dT = DL, dF(1)/dT = DH, where DL is the derivative of Y at the
*   first control point, and DH at the second control point.  We therefore
*   have the following set of values to solve for A thru D:
*
*         A        B        C        D   result
*   -------  -------  -------  -------  -------
*         0        0        0        1       Y0
*         1        1        1        1       Y1
*         0        0        1        0       DL
*         3        2        1        0       DH
*
*   This results in the following values for A thru D:
*
*   A = -2(Y1 - Y0) + DH + DL
*   B = 3(Y1 - Y0) - DH - 2DL
*   C = DL
*   D = Y0
}
got_interval:                          {L and H all set}
  ts := table[h].x - table[l].x;       {T to X scale factor}
  t := (x - table[l].x) / ts;          {normalized X to 0-1 over interval}
  dl := derivative(table, n, l) * ts;  {normalized derivative at L}
  dh := derivative(table, n, h) * ts;  {normalized derivative at H}
  dy := table[h].y - table[l].y;       {delta Y over interval}

  d := table[l].y;                     {fill in cubic interpolants}
  c := dl;
  b := 3.0 * dy - dh - 2.0 * dl;
  a := dh + dl - 2.0 * dy;

  math_ipolate3 := d + t*(c + t*(b + t*a)); {evaluate cubic equation}
  end;
