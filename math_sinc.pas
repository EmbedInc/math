{   Subroutine MATH_SINC (X)
*
*   Evaluate SINC function at X.
*
*               sin(X * Pi)
*   F(X) =    ---------------
*                 X * Pi
}
module math_sinc;
define math_sinc;
%include '/cognivision_links/dsee_libs/math/math2.ins.pas';

function math_sinc (                   {SINC function, SIN(PI*X)/(PI*X)}
  in      x: real)                     {input to equation above}
  :real;                               {result of equation above}
  val_param;

const
  pi = 3.14159265;                     {what it sound like, don't touch}

var
  r: real;

begin
  if abs(x) < 1.0E-6 then begin        {input value almost zero ?}
    math_sinc := 1.0;                  {known answer, prevent divide by zero}
    return;
    end;

  r := x * pi;
  math_sinc := sin(r) / r;
  end;
