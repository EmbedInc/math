{   Function MATH_BYTEVAL_SIGNED (C)
*
*   Convert an 8 bit byte to a signed integer.  The resulting integer
*   will have a value in the range of -128 to 127.
}
module math_byteval;
define math_byteval_signed;
%include 'math2.ins.pas';

function math_byteval_signed (         {convert any byte to a signed integer}
  in      c: univ char)                {input byte}
  :sys_int_machine_t;                  {integer value, -128 to 127}
  val_param;

begin
  if ord(c) <= 127
    then math_byteval_signed := ord(c) {signed byte is positive}
    else math_byteval_signed := 256 - ord(c); {signed byte is negative}
  end;
