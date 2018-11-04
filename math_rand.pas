{   Module of routines that return random numbers.
}
module math_rand;
define math_rand_int32;
define math_rand_int16;
define math_rand_int8;
define math_rand_real;
%include '/cognivision_links/dsee_libs/math/math2.ins.pas';
{
************************************************************
*
*   INTEGER32 Function MATH_RAND_INT32 (SEED)
*
*   Return a random 32 bit integer value, given the random number seed SEED.
*   SEED will be altered on return.
}
var
  patt: array[0..31] of integer32 := [
    16#F5C80F9B, 16#0D20F8E2, 16#1FD5A102, 16#A5593E2A,
    16#FC729FFC, 16#DC6BB1A4, 16#BBF7A406, 16#2238C93F,
    16#00A40508, 16#B83CAF82, 16#61915EBA, 16#5A4786C0,
    16#857D1146, 16#BECC8C73, 16#1324B7D2, 16#50ACE7C1,
    16#B82883D0, 16#8230DAB8, 16#9A318701, 16#50D1143F,
    16#FAB9C307, 16#E910D343, 16#985D87AE, 16#9DAE00D5,
    16#39118DDE, 16#452C12D7, 16#41A433C3, 16#8B44FB35,
    16#3F3DA54F, 16#35272BD1, 16#BCAE875C, 16#6B848796];

function math_rand_int32 (             {return a random 32 bit integer}
  in out  seed: math_rand_seed_t)      {random number seed, will be updated}
  :sys_int_conv32_t;                   {returned random 32 bit integer}

var
  sum: integer32;
  i: integer32;                        {loop counter}
  p: integer32;                        {random pattern array index}

begin
  p := rshft(seed.i32[1], 27);         {pick random pattern based on upper bits}
  sum := seed.i32[20] + patt[p];       {init random sum}
  for i := 20 downto 2 do begin        {backwards thru the SEED values}
    p := sum & 31;                     {pick new random pattern from list}
    sum := sum + seed.i32[i-1] + patt[p]; {make new random sum}
    seed.i32[i] := sum;                {update this seed entry}
    end;
  p := (p + 1) & 31;                   {make new random pattern index}
  sum := sum + patt[p];
  seed.i32[1] := sum;                  {update first seed entry}
  math_rand_int32 := sum;
  end;
{
************************************************************
*
*   Function MATH_RAND_INT16 (SEED)
*
*   Return a random 16 bit integer value, given the random number seed SEED.
*   SEED will be altered on return.
}
function math_rand_int16 (             {return a random 16 bit integer}
  in out  seed: math_rand_seed_t)      {random number seed, will be updated}
  :sys_int_conv16_t;                   {returned random 16 bit integer}

begin
  math_rand_int16 := rshft(math_rand_int32(seed), 11) & 16#FFFF;
  end;
{
************************************************************
*
*   Function MATH_RAND_INT8 (SEED)
*
*   Return a random 8 bit integer value, given the random number seed SEED.
*   SEED will be altered on return.
}
function math_rand_int8 (              {return a random 8 bit integer}
  in out  seed: math_rand_seed_t)      {random number seed, will be updated}
  :sys_int_conv8_t;                    {returned random 8 bit integer}

begin
  math_rand_int8 := rshft(math_rand_int32(seed), 11) & 16#FF;
  end;
{
************************************************************
*
*   Function MATH_RAND_REAL (SEED)
*
*   Return a random floating point value such that 0.0 <= VALUE < 1.0.
*   SEED will be updated.
}
function math_rand_real (              {return random real number}
  in out  seed: math_rand_seed_t)      {random number seed, will be updated}
  :real;                               {random real value >= 0.0 and < 1.0}

var
  r: real;

begin
  repeat
    r := (math_rand_int32(seed) & 16#3FFFFFFF) / 16#40000000;
    until r < 1.0;                     {R is almost never >= 1.0}
  math_rand_real := r;                 {pass back result}
  end;
