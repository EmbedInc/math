{   Module of routines for initializing a random number generator seed.
}
module math_rand_init;
define math_rand_init_int;
define math_rand_init_clock;
define math_rand_init_vstr;
%include 'math2.ins.pas';
{
*********************************************************************
*
*   Subroutine MATH_RAND_INIT_INT (I, SEED)
*
*   Initialize a random number seed from the integer value I.   SEED is
*   then useable with other random number calls.  I can have any value.
}
procedure math_rand_init_int (         {init random number seed from sytem integer}
  in      i: sys_int_machine_t;        {input integer value}
  out     seed: math_rand_seed_t);     {returned random number seed}
  val_param;

var
  v: sys_int_conv32_t;                 {current hashed value}
  s: sys_int_machine_t;                {current byte sum}
  n: sys_int_machine_t;                {loop counter}

begin
  v := i;                              {init hashed value}
  s := 16#55;                          {init current byte sum}
  for n := 1 to math_seed_char_k do begin {once for each byte in seed}
    s := s + v;                        {update sum}
    seed.str[n] := chr(s);             {stuff low 8 bits of sum into this seed byte}
    v := xor(rshft(v, 1), lshft(s, 17)); {udpate hashed value}
    end;

  for n := 1 to 20 do begin            {run the rand generator a few times}
    discard( math_rand_int32(seed) );
    end;
  end;
{
*********************************************************************
*
*   Subroutine MATH_RAND_INIT_CLOCK (SEED)
*
*   Init the random number generator seed SEED from the system clock.
}
procedure math_rand_init_clock (       {init random number seed from system clock}
  out     seed: math_rand_seed_t);     {returned random number seed}

var
  clock: sys_clock_t;                  {current clock value}
  i: sys_int_machine_t;                {loop counter}
  sum: sys_int_conv32_t;

begin
  clock := sys_clock;                  {get system clock value}

  sum := 16#55555555;
  for i := 1 to math_seed_i32_k do begin {once for each 32 bit integer in seed}
    seed.i32[i] := clock.low;
    sum := sum + clock.low;
    clock.low := clock.low + clock.sec;
    clock.sec := clock.sec + clock.high;
    clock.high := xor(clock.high, sum);
    end;

  for i := 1 to 20 do begin            {run the rand generator a few times}
    discard( math_rand_int32(seed) );
    end;
  end;
{
*********************************************************************
*
*   Subroutine MATH_RAND_INIT_VSTR (VSTR, SEED)
*
*   Initialize the random number generator seed SEED from the var string VSTR.
}
procedure math_rand_init_vstr (        {init random number seed from var string}
  in      vstr: univ string_var_arg_t; {input string}
  out     seed: math_rand_seed_t);     {returned random number seed}
  val_param;

var
  s: sys_int_machine_t;                {SEED string array index}
  v: sys_int_machine_t;                {VSTR string array index}

begin
  if vstr.len > math_seed_char_k
    then begin                         {user string is longer than seed string}
      for s := 1 to math_seed_char_k do begin {copy first line of chars into seed}
        seed.str[s] := vstr.str[s];
        end;
      s := 1;                          {init next seed index}
      for v := math_seed_char_k+1 to vstr.len do begin {once for each remaining char}
        seed.str[s] := chr(ord(seed.str[s]) + ord(vstr.str[v])); {add in char}
        s := s + 1;
        if s > math_seed_char_k then s := 1; {wrap back to start of seed string}
        end;                           {back to do next char from user string}
      end
    else begin                         {user string does not exceed seed string}
      for s := 1 to math_seed_char_k do begin {once for each seed char to set}
        if s <= vstr.len
          then begin                   {still within user string}
            seed.str[s] := vstr.str[s]; {copy char from user string}
            end
          else begin                   {past end of user string}
            seed.str[s] := chr(s - vstr.len - 1); {count up from zero}
            end
          ;
        end;                           {back to fill next seed string character}
      end
    ;                                  {done setting all chars in seed string}

  for s := 1 to 20 do begin            {run the rand generator a few times}
    discard( math_rand_int32(seed) );
    end;
  end;
