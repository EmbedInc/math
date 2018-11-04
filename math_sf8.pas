module math_sf8;
define math_sf8_calc_coef;
define math_sf8_val;
define math_sf8_dxdu;
define math_sf8_dxdv;
%include '/cognivision_links/dsee_libs/math/math2.ins.pas';
{
*******************************************************************************
*
*   Subroutine MATH_SF8_CALC_COEF (X1, X2, X3, X4, X5, X6, X7, X8, C)
*
*   Calculate the coefficients for an 8 point function.
*   The shape function the following form:
*
*     f(u,v) = A*u**2 + B*u*v + C*v**2 + D*u + E*v + F*u**2*v + G*u*v**2 + H
*
*   Where C.A thru C.H are the returned coefficients and the
*   eight known function values are input as X1 thru X8 and
*   defined in the following figure and table:
*
*                               V
*                               ^
*   u | v | x            X7(0,2)|     X6(1,2)      X5(2,2)
*  ------------                 *--------*--------*
*   0 | 0 | X1                  |                 |
*   1 | 0 | X2                  |                 |
*   2 | 0 | X3                  |                 |
*   2 | 1 | X4           X8(0,1)*                 *X4(2,1)
*   2 | 2 | X5                  |                 |
*   1 | 2 | X6                  |                 |
*   0 | 2 | X7                  |                 |
*   0 | 1 | X8               ---*--------*--------*----> u
*                        X1(0,0)|     X2(1,0)      X3(2,0)
*
}
procedure math_sf8_calc_coef (         {calculate coef. for 8 point shape function}
  in      x1, x2, x3, x4, x5, x6, x7, x8: real; {8 values of sf at boundary cond's}
  out     c: math_sf8_coef_t);         {8 calculated coefficients of shape function}
  val_param;

begin
  c.h := x1;
  c.a := (x3 - 2.0*x2 + x1)*0.5;
  c.d := (4.0*x2 - 3.0*x1 - x3)*0.5;
  c.c := (x7 + x1)*0.5 - x8;
  c.e := -0.5*x7 + 2.0*x8 - 1.5*x1;
  c.f := 0.5*(c.e - c.a - x6) + c.c + 0.25*(x5 + x1);
  c.g := c.a + 0.5*(c.d - c.c - x4) + 0.25*(x5 + x1);
  c.b := -2.0*(c.a + c.f) - 0.5*(c.c + c.e + x1 - x4) - c.d - c.g;
  end;
{
*******************************************************************************
*
*   function MATH_SF8_VAL (U, V, C)
*
*   Return the value of an 8 point shape function having coefficients given
*   by C.
*
}
function math_sf8_val (                {calculate value of 8 point shape function}
  in      u, v: real;                  {u,v coordinates of value desired}
  in      c: math_sf8_coef_t)          {coefficients of shape function}
  :real;
  val_param;

begin
  math_sf8_val :=
    u*(u*(c.a + c.f*v) + (c.b*v + c.d)) +
    v*(v*(c.c + c.g*u) + c.e) + c.h;
  end;
{
*******************************************************************************
*
*   function MATH_SF8_DXDU (U, V, C)
*
*   Return the value of the partial derivative with respect to U of an 8 point
*   shape function having coefficients given by C.
*
}
function math_sf8_dxdu (               {calc. partial derivative with respect to u}
  in      u, v: real;                  {u,v coordinates of derivative desired}
  in      c: math_sf8_coef_t)          {coefficients of shape function}
  :real;
  val_param;

begin
  math_sf8_dxdu := v*(c.b + 2.0*c.f*u + c.g*v) + 2.0*c.a*u + c.d;
  end;
{
*******************************************************************************
*
*   function MATH_SF8_DXDV (U, V, C)
*
*   Return the value of the partial derivative with respect to V of an 8 point
*   shape function having coefficients given by C.
*
}
function math_sf8_dxdv (               {calc. partial derivative with respect to v}
  in      u, v: real;                  {u,v coordinates of derivative desired}
  in      c: math_sf8_coef_t)          {coefficients of shape function}
  :real;
  val_param;

begin
  math_sf8_dxdv := u*(c.b + c.f*u + 2.0*c.g*v) + 2.0*c.c*v + c.e;
  end;
