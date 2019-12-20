@echo off
rem
rem   Define the variables for running builds from this source library.
rem
set srcdir=math
set buildname=
call treename_var "(cog)source/math" sourcedir
set libname=math
set fwname=
call treename_var "(cog)src/%srcdir%/debug_%fwname%.bat" tnam
make_debug "%tnam%"
call "%tnam%"
