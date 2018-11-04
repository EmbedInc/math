module math_sf4;
define math_sf4_calc_coef;
define math_sf4_val;
define math_sf4_dxdu;
define math_sf4_dxdv;
%include '/cognivision_links/dsee_libs/math/math2.ins.pas';
{
*******************************************************************************
*
*   Subroutine MATH_SF4_CALC_COEF (X1, X2, X3, X4, C)
*
*   Calculate the coefficients of a four point shape function.
*   The shape function has the following form:
*
*     f(u,v) = A*u + B*u*v + C*v + D
*
*   Where C.A thru C.D are the returned coefficients and the
*   four known function values are input as X1 thru X4 and
*   defined in the following figure and table:
*
*                               V
*                               ^
*   u | v | x            X4(0,1)|         X3(1,1)
*  ------------                 *--------*
*   0 | 0 | X1                  |        |
*   1 | 0 | X2                  |        |
*   1 | 1 | X3                  |        |
*   0 | 1 | X4                  *--------*----> u
*                        X1(0,0)|         X2(1,0)
*
}
procedure math_sf4_calc_coef (         {calculate coef. for 4 point shape function}
  in      x1, x2, x3, x4: real;        {4 values of sf at boundary conditions}
  out     c: math_sf4_coef_t);         {4 calculated coefficients of shape function}
  val_param;

begin
  c.d := x1;
  c.a := x2 - c.d;
  c.c := x4 - c.d;
  c.b := x3 - c.a - c.c - c.d;
  end;
{
*******************************************************************************
*
*   function MATH_SF4_VAL (U, V, C)
*
*   Return the value of a 4 point shape function having coefficients given
*   by C.
*
}
function math_sf4_val (                {calculate value of 4 point shape function}
  in      u, v: real;                  {u,v coordinates of value desired}
  in      c: math_sf4_coef_t)          {coefficients of shape function}
  :real;
  val_param;

begin
  math_sf4_val := u*(c.a + c.b*v) + c.c*v + c.d;
  end;
{
*******************************************************************************
*
*   function MATH_SF4_DXDU (U, V, C)
*
*   Return the value of the partial derivative with respect to U of a 4 point
*   shape function having coefficients given by C.
*
}
function math_sf4_dxdu (               {calc. partial derivative with respect to u}
  in      u, v: real;                  {u,v coordinates of derivative desired}
  in      c: math_sf4_coef_t)          {coefficients of shape function}
  :real;
  val_param;

begin
  math_sf4_dxdu := c.a + c.b*v;
  end;
{
*******************************************************************************
*
*   function MATH_SF4_DXDV (U, V, C)
*
*   Return the value of the partial derivative with respect to V of a 4 point
*   shape function having coefficients given by C.
*
}
function math_sf4_dxdv (               {calc. partial derivative with respect to v}
  in      u, v: real;                  {u,v coordinates of derivative desired}
  in      c: math_sf4_coef_t)          {coefficients of shape function}
  :real;
  val_param;

begin
  math_sf4_dxdv := c.b*u + c.c;
  end;
