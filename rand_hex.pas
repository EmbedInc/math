{   Program RAND_HEX [<string> [<n numbers>]]
*
*   Print a bunch of random hexadecimal numbers.
*
*   The first command line argument STRING is used as the seed to
*   the random number generator.  If the argument it is not provided
*   the current data/time string is used.
*
*   The second command line argument indicates the number of random numbers
*   to print.  The default is 32.
}
program rand_hex;
%include '/cognivision_links/dsee_libs/sys/sys.ins.pas';
%include '/cognivision_links/dsee_libs/util/util.ins.pas';
%include '/cognivision_links/dsee_libs/string/string.ins.pas';
%include '/cognivision_links/dsee_libs/math/math.ins.pas';

const
  n_numbers_default = 32;              {default number of random numbers to print}

var
  seed: math_rand_seed_t;              {seed for random number generator}
  n_numbers: sys_int_machine_t;        {number of random numbers to print}
  i: sys_int_machine_t;                {loop counter}
  rand: sys_int_conv32_t;              {32 bit random number}
  token:
    %include '/cognivision_links/dsee_libs/string/string32.ins.pas';
  stat: sys_err_t;                     {completion status}

begin
  string_cmline_init;                  {initialize command line input}

  string_cmline_token (token, stat);   {get optional seed from command line}
  if string_eos(stat) then begin
    sys_date_time1 (token);            {use current date/time string as seed}
    end;
  sys_error_abort (stat, '', '', nil, 0); {check for any other errors}

  string_cmline_token_int (n_numbers, stat); {get options second command line arg}
  if string_eos(stat) then begin
    n_numbers := n_numbers_default;
    end;
  sys_error_abort (stat, '', '', nil, 0); {check for any other errors}

  string_cmline_end_abort;             {abort if unread tokens left on command line}

  string_fill (token);                 {set unused characters to blank}
  seed.str := token.str;               {estabish seed}

  for i := 1 to n_numbers do begin     {once for each random number to print}
    rand := math_rand_int32(seed);     {get random number}
    string_f_int32h (token, rand);     {convert to hex string}
    writeln (token.str:token.len);
    end;
  end.
