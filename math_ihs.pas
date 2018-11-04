{   Module of routines for dealing with intensity, hue, saturation (IHS)
*   colors.
}
module math_ihs;
define math_ihs_rgb;
define math_rgb_ihs;
%include '/cognivision_links/dsee_libs/math/math2.ins.pas';
{
********************************************************************
*
*   Subroutine MATH_IHS_RGB (I, H, S, R, G, B)
*
*   Convert from IHS color space to RGB color space.  The I, H, and S arguments
*   are supplied, and the R, G, and B arguments are returned.  Their meaning
*   is as follows:
*
*   I - Intensity.  Black is 0, and max intensity is 1.
*
*   H - Hue.  In this model, hue can continously wrap around.  Red is 0,
*       green is 1, blue is 2, and 3 wraps back to red.  Therefore magenta
*       is 2.5 and orange is .25.
*
*   S - Saturation.  Minimum saturation (a shade of gray) is 0 and maximum
*       saturation is 1.
*
*   R,G,B - The individual red, green, and blue color intensities.  minimum
*       intensity is 0 and maximum intensity is 1.
}
procedure math_ihs_rgb (               {convert IHS color to RGB color}
  in      i, h, s: real;               {input intensity, hue, saturation (0.0 to 1.0)}
  out     r, g, b: real);              {output red, green, blue (0.0 to 1.0)}
  val_param;

var
  red, grn, blu,                       {internal color values}
  m, ofs,                              {linear equation coeficients}
  mi, mx,                              {min and max of raw rgb values}
  hue: real;                           {internal hue value}

begin
  hue := h - (trunc (h / 3.0) * 3.0);  {wrap hue to -3,+3 range}
  if hue < 0.0 then hue := hue + 3.0;  {hue is in 0,+3 range}
  red := abs(hue-1.5);                 {red raw color value}
  hue := hue-1.0;                      {shift green to zero}
  if hue < 0.0 then hue := hue + 3.0;  {wrap to 0,+3 range}
  grn := abs(hue-1.5);                 {green raw color}
  hue := hue-1.0;                      {shift blue to zero}
  if hue < 0.0 then hue := hue + 3.0;  {wrap to 0,+3 range}
  blu := abs(hue-1.5);                 {blue raw color}
{
*   The initial colors based only on hue are set.  Now find the min and max
*   of the three color values.
}
  mi := min(red, min(grn, blu));
  mx := max(red, max(grn, blu));
{
*   MI is the min of RGB and MX is the max of RGB.  Now shift and scale
*   the raw RGB values derived from hue alone to get the final color
*   values.  This is done by applying the same linear equation to all three
*   color values.  M is the multiplication factor, and OF is the offset
*   of this linear equation.  Now calculate M and OF.
}
  m := s*i / (mx-mi);                  {scale so max range is s*i}
  ofs := i - mx*m;                     {shift so max ends up at i}
{
*   The coeficients M and B for the linear equation are all set up.  Now
*   transform the raw color values to the final ones.
}
  r := red*m + ofs;                    {linear shift for final values}
  g := grn*m + ofs;
  b := blu*m + ofs;
  end;
{
********************************************************************
*
*   Subroutine MATH_RGB_IHS (R,G,B,I,H,S)
*
*   Convert RGB color to IHS color.  For the formats of RGB and IHS, see
*   the header comments of subroutine IHS_RGB.
}
procedure math_rgb_ihs (               {convert RGB color to IHS color}
  in      r, g, b: real;               {input red, green, blue (0.0 to 1.0)}
  out     i, h, s: real);              {output intensity, hue, saturation (0.0 to 1.0)}
  val_param;

var
  mx: real;                            {max rgb value}
  md: real;                            {middle rgb value}
  mi: real;                            {min rgb value}
  r4: real;                            {scratch real number}
  imx, imd, imi: sys_int_machine_t;    {color number of max,mid,min}

begin
{
*   First the RGB colors are sorted into MX, MD, and MI.  Together with these,
*   IMX, IMD, and IMI are set to the corresponding hue number of that color.
*   The sort is done by a "written out" exchange sort, since there are only
*   three values to sort.
}
  if r < g
    then begin                         {init max to green}
      mx := g;                         {init max color}
      imx := 1;                        {hue number of max}
      md := r;                         {init middle color}
      imd := 0;                        {hue number of middle color}
      end
    else begin                         {init max to red}
      mx := r;                         {max color}
      imx := 0;                        {hue number of max}
      md := g;                         {init middle color}
      imd := 1;                        {hue number of middle color}
      end
    ;

  if mx < b
    then begin                         {blue replaces max}
      mi := mx;                        {swap old max to min}
      imi := imx;
      mx := b;                         {set new max to blue}
      imx := 2;
      end
    else begin                         {blue not bigger than max}
      mi := b;                         {set min color to blue}
      imi := 2;
      end
    ;

  if md < mi
    then begin                         {mid,min not in right order}
      r4 := md;                        {swap mid and min color values}
      md := mi;
      mi := r4;
      imd := imi;
      end
    ;
{
*   The sorted RGB color values are in MX,MD,MI.  Their corresponding hue
*   numbers are in IMX,IMD,IMI.  Now start computing IHS.
}
  if mx < 0.1e-5 then begin            {color is black special case}
    i := 0.0;
    h := 0.0;
    s := 0.0;
    return;
    end;

  i := mx;                             {intensity}
  r4 := mx-mi;                         {max range of rgb values}
  if r4 < 0.1e-5 then begin            {range is 0 (gray) special case}
    h := 0.0;
    s := 0.0;
    return;
    end;

  s := r4/mx;                          {saturation}
  mx := -(mx-(mx+md)/2.0)/r4+0.5;      {hue deviation from max color}
  if (imx+1 mod 3) = imd
    then begin                         {deviation in positive direction}
      h := imx+mx;                     {hue}
      end
    else begin                         {deviation in negative direction}
      h := imx-mx;                     {hue}
      if h < 0.0 then h := h + 3.0;    {wrap hue to primary 0-3 range}
      end
    ;
  end;
