{   Routines that operate on angles.
*
*   Math angles
*
*     Math angle is the name used here for the type of angle representation
*     commonly used in mathematics.  Angles from the origin in the X-Y plane are
*     0 along the +X axis +pi/2 along the +Y axis, and -pi/2 along the -Y axis.
*
*   Survey angles
*
*     In land surveying, the 0 angle is north, straight ahead, or relative to
*     some explicitly stated reference direction.  The direction is more
*     clockwise for increasing angles when viewed from above.  Since north is
*     usually drawn up on 2D plots, the 0 angle is along the +Y axis.  The +X
*     axis is at +90 degrees, and the -X axis at -90 or +270 degrees.  Survey
*     angles differ from math angles in that their 0 is 90 deg left, and the
*     direction of increasing angle is opposite.
*
*   Angles in this software are in radians unless explicitly stated otherwise.
}
module math_angle;
define math_angle_math;
define math_angle_surv;
define math_angle_wrapq;
%include 'math2.ins.pas';
{
********************************************************************************
*
*   Function MATH_ANGLE_MATH (SANG)
*
*   Returns the math angle, given the survey angle SANG.  The resulting angle is
*   wrapped to the 0 to 2pi range if one revolution or less outside.
}
function math_angle_math (             {convert to survey to math angle}
  in      sang: real)                  {survey angle}
  :real;                               {equivalent math angle}
  val_param;

var
  mang: real;                          {math angle}

begin
  mang := math_hpi - sang;             {convert to math angle}
  if mang >= math_2pi then mang := mang - math_2pi; {try to wrap to 0-2pi range}
  if mang < 0.0 then mang := mang + math_2pi;
  math_angle_math := mang;             {pass back the result}
  end;
{
********************************************************************************
*
*   Function MATH_ANGLE_SURV (MANG)
*
*   Returns the survey angle, given the math angle MANG.  The resulting angle is
*   wrapped to the 0 to 2pi range if one revolution or less outside.
}
function math_angle_surv (             {convert math angle to survey angle}
  in      mang: real)                  {math angle}
  :real;                               {equivalent survey angle}
  val_param;

var
  sang: real;                          {survey angle}

begin
  sang := math_hpi - mang;             {convert to survey angle}
  if sang >= math_2pi then sang := sang - math_2pi; {try to wrap to 0-2pi range}
  if sang < 0.0 then sang := sang + math_2pi;
  math_angle_surv := sang;             {pass back the result}
  end;
{
********************************************************************************
*
*   Function MATH_ANGLE_WRAPQ (ANG)
*
*   Wrap an angle into the 0 to 2pi range.  This is a "quick" version that can
*   only add or subtract up to one full circle from the angle.
}
function math_angle_wrapq (            {do "quick" wrap of angle into 0-2pi range}
  in      ang: real)                   {input angle, radians}
  :real;                               {result, wrapped up to one circle + or -}
  val_param;

begin
  if ang >= math_2pi
    then begin
      math_angle_wrapq := ang - math_2pi;
      end
    else begin
      if ang < 0.0
        then begin
          math_angle_wrapq := ang + math_2pi;
          end
        else begin
          math_angle_wrapq := ang;
          end
        ;
      end;
    ;
  end;
