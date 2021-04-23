{   Public include file to define entry points and data types for the
*   MATH library.
}
const
{
*   Mathematical constants.
}
  math_pi = 3.14159265358979323846;    {what it sounds like, don't touch}
  math_2pi = 2.0 * math_pi;            {2 pi, radians in a full circle}
  math_hpi = 0.5 * math_pi;            {half pi, radians in 90 degrees}
  math_rad_deg = 180.0 / math_pi;      {factor to convert radians to degrees}
  math_deg_rad = math_pi / 180.0;      {factor to convert degrees to radians}
{
*   Configuration parameters for the MATH library.
}
  math_seed_char_k = 80;               {number of characters in random seed}
  math_seed_i16_k =                    {number of 16 bit integers in random seed}
    math_seed_char_k div 2;
  math_seed_i32_k =                    {number of 32 bit integers in random seed}
    math_seed_char_k div 4;

type
  math_real_ar_arg_t = array[1..1] of real; {for call args of unknown length}

  math_xy_t = record                   {One X,Y pair}
    x: real;
    y: real;
    end;

  math_funar_arg_t =                   {for arbitrary length list of XY pairs arg}
    array[1..1] of math_xy_t;

  math_rand_seed_t = record case integer of {template for random number seed}
    1: (str: array[1..math_seed_char_k] of char); {string overlay}
    2: (i16: array[1..math_seed_i16_k] of int16u_t); {16 bit integer overlay}
    3: (i32: array[1..math_seed_i32_k] of int32u_t); {32 bit integer overlay}
    end;

  math_sf4_coef_t = record             {coefficients for 4 point shape function}
    a, b, c, d: real;
    end;
  math_sf4_coef_p_t = ^math_sf4_coef_t;

  math_sf6_coef_t = record             {coefficients for 6 point shape function}
    a, b, c, d, e, f: real;
    end;
  math_sf6_coef_p_t = ^math_sf6_coef_t;

  math_sf8_coef_t = record             {coefficients for 8 point shape function}
    a, b, c, d, e, f, g, h: real;
    end;
  math_sf8_coef_p_t = ^math_sf8_coef_t;

  math_sf_k_t = (                      {shape function types}
    math_sf_none_k,                    {no shape function}
    math_sf_4pnt_k,                    {4 point shape function}
    math_sf_6pnt_k,                    {6 point shape function}
    math_sf_8pnt_k);                   {8 point shape function}

  math_sf_coef_t = record              {general shape function}
    typ: math_sf_k_t;                  {type of shape function}
    case math_sf_k_t of
math_sf_4pnt_k: (                      {4 point shape function}
      sf4: math_sf4_coef_t
      );
math_sf_6pnt_k: (                      {6 point shape function}
      sf6: math_sf6_coef_t
      );
math_sf_8pnt_k: (                      {8 point shape function}
      sf8: math_sf8_coef_t
      );
    end;
{
*   Entry point definitions.
}
function math_byteval_signed (         {convert any byte to a signed integer}
  in      c: univ char)                {input byte}
  :sys_int_machine_t;                  {integer value, -128 to 127}
  val_param; extern;

procedure math_ihs_rgb (               {convert IHS color to RGB color}
  in      i, h, s: real;               {input intensity, hue, saturation (0.0 to 1.0)}
  out     r, g, b: real);              {output red, green, blue (0.0 to 1.0)}
  val_param; extern;

function math_ipolate (                {linearly interpolate into table of values}
  in      funar: univ math_funar_arg_t; {N pairs of XY values}
  in      n: sys_int_machine_t;        {number of XY pairs in FUNAR array}
  in      x: real)                     {input value where to evaluate table at}
  :real;                               {interpolated Y value from table}
  val_param; extern;

function math_ipolate3 (               {cubically interpolate into table of values}
  in      table: univ math_funar_arg_t; {pairs of XY values}
  in      n: sys_int_machine_t;        {number of XY pairs in TABLE array}
  in      x: real)                     {input value where to evaluate table at}
  :double;                             {interpolated Y value from table}
  val_param; extern;

function math_log2 (                   {find logarithm base 2}
  in      r: real)                     {number to find log of}
  :real;                               {returned logarithm}
  val_param; extern;

function math_log10 (                  {find logarithm base 10}
  in      r: real)                     {number to find log of}
  :real;                               {returned logarithm}
  val_param; extern;

procedure math_rand_init_clock (       {init random number seed from system clock}
  out     seed: math_rand_seed_t);     {returned random number seed}
  extern;

procedure math_rand_init_int (         {init random number seed from system integer}
  in      i: sys_int_machine_t;        {input integer value}
  out     seed: math_rand_seed_t);     {returned random number seed}
  val_param; extern;

procedure math_rand_init_vstr (        {init random number seed from var string}
  in      vstr: univ string_var_arg_t; {input string}
  out     seed: math_rand_seed_t);     {returned random number seed}
  val_param; extern;

function math_rand_int8 (              {return a random 8 bit integer}
  in out  seed: math_rand_seed_t)      {random number seed, will be updated}
  :sys_int_conv8_t;                    {returned random 8 bit integer}
  extern;

function math_rand_int16 (             {return a random 16 bit integer}
  in out  seed: math_rand_seed_t)      {random number seed, will be updated}
  :sys_int_conv16_t;                   {returned random 16 bit integer}
  extern;

function math_rand_int32 (             {return a random 32 bit integer}
  in out  seed: math_rand_seed_t)      {random number seed, will be updated}
  :sys_int_conv32_t;                   {returned random 32 bit integer}
  extern;

function math_rand_real (              {return random real number}
  in out  seed: math_rand_seed_t)      {random number seed, will be updated}
  :real;                               {random real value >= 0.0 and < 1.0}
  extern;

procedure math_rgb_ihs (               {convert RGB color to IHS color}
  in      r, g, b: real;               {input red, green, blue (0.0 to 1.0)}
  out     i, h, s: real);              {output intensity, hue, sat (0.0 to 1.0)}
  val_param; extern;

procedure math_sf4_calc_coef (         {calculate coef. for 4 point shape function}
  in      x1, x2, x3, x4: real;        {4 values of sf at boundary conditions}
  out     c: math_sf4_coef_t);         {4 calculated coefficients of shape function}
  val_param; extern;

function math_sf4_dxdu (               {calc. partial derivative with respect to u}
  in      u, v: real;                  {u,v coordinates of derivative desired}
  in      c: math_sf4_coef_t)          {coefficients of shape function}
  :real;
  val_param; extern;

function math_sf4_dxdv (               {calc. partial derivative with respect to v}
  in      u, v: real;                  {u,v coordinates of derivative desired}
  in      c: math_sf4_coef_t)          {coefficients of shape function}
  :real;
  val_param; extern;

function math_sf4_val (                {calculate value of 4 point shape function}
  in      u, v: real;                  {u,v coordinates of value desired}
  in      c: math_sf4_coef_t)          {coefficients of shape function}
  :real;
  val_param; extern;

procedure math_sf6_calc_coef (         {calculate coef. for 6 point shape function}
  in      x1, x2, x3, x4, x5, x6: real; {6 values of sf at boundary conditions}
  out     c: math_sf6_coef_t);         {6 calculated coefficients of shape function}
  val_param; extern;

function math_sf6_dxdu (               {calc. partial derivative with respect to u}
  in      u, v: real;                  {u,v coordinates of derivative desired}
  in      c: math_sf6_coef_t)          {coefficients of shape function}
  :real;
  val_param; extern;

function math_sf6_dxdv (               {calc. partial derivative with respect to v}
  in      u, v: real;                  {u,v coordinates of derivative desired}
  in      c: math_sf6_coef_t)          {coefficients of shape function}
  :real;
  val_param; extern;

function math_sf6_val (                {calculate value of 6 point shape function}
  in      u, v: real;                  {u,v coordinates of value desired}
  in      c: math_sf6_coef_t)          {coefficients of shape function}
  :real;
  val_param; extern;

procedure math_sf8_calc_coef (         {calculate coef. for 8 point shape function}
  in      x1, x2, x3, x4, x5, x6, x7, x8: real; {8 values of sf at boundary cond's}
  out     c: math_sf8_coef_t);         {8 calculated coefficients of shape function}
  val_param; extern;

function math_sf8_dxdu (               {calc. partial derivative with respect to u}
  in      u, v: real;                  {u,v coordinates of derivative desired}
  in      c: math_sf8_coef_t)          {coefficients of shape function}
  :real;
  val_param; extern;

function math_sf8_dxdv (               {calc. partial derivative with respect to v}
  in      u, v: real;                  {u,v coordinates of derivative desired}
  in      c: math_sf8_coef_t)          {coefficients of shape function}
  :real;
  val_param; extern;

function math_sf8_val (                {calculate value of 8 point shape function}
  in      u, v: real;                  {u,v coordinates of value desired}
  in      c: math_sf8_coef_t)          {coefficients of shape function}
  :real;
  val_param; extern;

function math_sign_int (               {return sign (+1, 0, -1) of integer}
  in      i: sys_int_machine_t)        {number to return sign of}
  :sys_int_machine_t;
  val_param; extern;

function math_sinc (                   {SINC function, SIN(PI*X)/(PI*X)}
  in      x: real)                     {input to equation above}
  :real;                               {result of equation above}
  val_param; extern;

procedure math_simul (                 {solve simultaneous equations}
  in      n: sys_int_machine_t;        {number of equations}
  var     user_matrix: univ math_real_ar_arg_t; {the equations}
  out     answer: univ math_real_ar_arg_t; {answer array}
  out     valid: boolean);             {true if could find answer}
  val_param; extern;
