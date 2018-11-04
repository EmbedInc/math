module math_log;
define math_log2;
define math_log10;
%include 'math2.ins.pas';
{
*************************************
*
*   Function MATH_LOG2 (R)
*
*   Return the log base 2 of R.
}
function math_log2 (                   {find logarithm base 2}
  in      r: real)                     {number to find log of}
  :real;                               {returned logarithm}
  val_param;

const
  ln2r = 1.0 / ln(2.0);                {for converting natural log to LOG2}

begin
  math_log2 := ln(r) * ln2r;
  end;
{
*************************************
*
*   Function MATH_LOG10 (R)
*
*   Return the log base 10 of R.
}
function math_log10 (                  {find logarithm base 10}
  in      r: real)                     {number to find log of}
  :real;                               {returned logarithm}
  val_param;

const
  ln10r = 1.0 / ln(10.0);              {for converting natural log to LOG10}

begin
  math_log10 := ln(r) * ln10r;
  end;
