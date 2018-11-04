{   Function MATH_SIGN_INT (I)
*
*   Return the sign of I.  This will be +1 if I is greater than zero,
*   -1 if I is less than zero, and 0 if I is equal to zero.
}
module math_sign_int;
define math_sign_int;
%include 'math2.ins.pas';

function math_sign_int (               {return sign (+1, 0, -1) of integer}
  in      i: sys_int_machine_t)        {number to return sign of}
  :sys_int_machine_t;
  val_param;

begin
  if i = 0 then begin                  {exactly zero ?}
    math_sign_int := 0;
    return;
    end;
  if i > 0
    then                               {positive}
      math_sign_int := 1
    else                               {negative}
      math_sign_int := -1;
  end;
