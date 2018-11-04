{   Subroutine MATH_IPOLATE (FUNAR, N, X)
*
*   Return the value of the function in the function array FUNAR evaluated
*   at point X.  FUNAR contains N pairs of XY numbers in increasing order
*   of X.  For X values outside the range in the function array, the appropriate
*   end point Y value is returned.  A binary search is done to find the
*   two adjacent points in the function array to X.  The function is then
*   linearly interpolated between these two points to determine the Y value
*   returned.
}
module math_ipolate;
define math_ipolate;
%include '/cognivision_links/dsee_libs/math/math2.ins.pas';

function math_ipolate (                {linearly interpolate into table of values}
  in      funar: univ math_funar_arg_t; {N pairs of XY values}
  in      n: sys_int_machine_t;        {number of XY pairs in FUNAR array}
  in      x: real)                     {input value where to evaluate table at}
  :real;                               {interpolated Y value from table}
  val_param;

var
  st, en: sys_int_machine_t;           {indicies for start/end of current interval}
  md: sys_int_machine_t;               {index for middle of interval}
  m: real;                             {multiplier value}

begin
  if n <= 1 then begin                 {function has only one value ?}
    math_ipolate := funar[1].y;
    return;
    end;
  if x <= funar[1].x then begin        {before start of function ?}
    math_ipolate := funar[1].y;
    return;
    end;
  if x >= funar[n].x then begin        {after end of function ?}
    math_ipolate := funar[n].y;
    return;
    end;
{
*   The function table contains at least 2 points, and X is somewhere within
*   the function table's range.
*
*   Now look for the two function entries at either side of X.  This will
*   be done by binary iteration.  The interval containing X is initialized
*   to the whole table, then successively narrowed until the interval
*   is between adjacent table entries.
}
  st := 1;                             {init start index of interval}
  en := n;                             {init end index of interval}
  while en > (st + 1) do begin         {loop until interval is one segment}
    md := (st + en) div 2;             {make index to near middle of interval}
    if x < funar[md].x
      then begin                       {X is in left part}
        en := md;                      {move right end to middle}
        end
      else begin                       {X is in right part}
        st := md;                      {move left end ot middle}
        end
      ;
    end;                               {back and try again with this new interval}
{
*   ST and EN are the start and end indicies to the final interval.  Now
*   linearly interpolate Y value.
}
  m := (x - funar[st].x) / (funar[en].x - funar[st].x); {mult factor for end value}
  math_ipolate :=                      {pass back final interpolated value}
    ((1.0 - m) * funar[st].y) + (m * funar[en].y);
  end;
