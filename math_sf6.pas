module math_sf6;
define math_sf6_calc_coef;
define math_sf6_val;
define math_sf6_dxdu;
define math_sf6_dxdv;
%include '/cognivision_links/dsee_libs/math/math2.ins.pas';
{
*******************************************************************************
*
*   Subroutine MATH_SF6_CALC_COEF (X1, X2, X3, X4, X5, X6, C)
*
*   Calculate the coefficients of a six point shape function.
*   The shape function has the following form:
*
*     f(u,v) = A*u**2 + B*u*v + C*v**2 + D*u + E*v + F
*
*   Where C.A thru C.F are the returned coefficients and the
*   six known function values are input as X1 thru X6 and
*   defined in the following figure and table:
*
*                               V
*                               ^
*   u | v | x            X5(0,2)|
*  ------------                 *
*   0 | 0 | X1                  | .
*   1 | 0 | X2                  |   .
*   2 | 0 | X3                  |     .
*   1 | 1 | X4           X6(0,1)*        * X4(1,1)
*   0 | 2 | X5                  |          .
*   0 | 1 | X6                  |            .
*                               |              .
*                            ---*--------*--------*----> u
*                        X1(0,0)|     X2(1,0)      X3(2,0)
*
}
procedure math_sf6_calc_coef (         {calculate coef. for 6 point shape function}
  in      x1, x2, x3, x4, x5, x6: real; {6 values of sf at boundary conditions}
  out     c: math_sf6_coef_t);         {6 calculated coefficients of shape function}
  val_param;

begin
  c.f := x1;
  c.a := -x2 + (x3 + x1)*0.5;
  c.d := (4.0*x2 - 3.0*x1 - x3)*0.5;
  c.c := (x5 + x1)*0.5 - x6;
  c.e := -0.5*x5 + 2.0*x6 - 1.5*x1;
  c.b := x4 - c.a - c.c - c.d - c.e - c.f;
  end;
{
*******************************************************************************
*
*   function MATH_SF6_VAL (U, V, C)
*
*   Return the value of a 6 point shape function having coefficients given
*   by C.
*
}
function math_sf6_val (                {calculate value of 6 point shape function}
  in      u, v: real;                  {u,v coordinates of value desired}
  in      c: math_sf6_coef_t)          {coefficients of shape function}
  :real;
  val_param;

begin
  math_sf6_val := u*(u*c.a + (c.b*v + c.d)) + v*(v*c.c + c.e) + c.f;
  end;
{
*******************************************************************************
*
*   function MATH_SF6_DXDU (U, V, C)
*
*   Return the value of the partial derivative with respect to U of a 6 point
*   shape function having coefficients given by C.
*
}
function math_sf6_dxdu (               {calc. partial derivative with respect to u}
  in      u, v: real;                  {u,v coordinates of derivative desired}
  in      c: math_sf6_coef_t)          {coefficients of shape function}
  :real;
  val_param;

begin
  math_sf6_dxdu := 2.0*u*c.a + c.b*v + c.d;
  end;
{
*******************************************************************************
*
*   function MATH_SF6_DXDV (U, V, C)
*
*   Return the value of the partial derivative with respect to V of a 6 point
*   shape function having coefficients given by C.
*
}
function math_sf6_dxdv (               {calc. partial derivative with respect to v}
  in      u, v: real;                  {u,v coordinates of derivative desired}
  in      c: math_sf6_coef_t)          {coefficients of shape function}
  :real;
  val_param;

begin
  math_sf6_dxdv := u*c.b + 2.0*v*c.c + c.e;
  end;
