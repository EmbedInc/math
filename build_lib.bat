@echo off
rem
rem   BUILD_LIB [-dbg]
rem
rem   Build the MATH library.
rem
setlocal
call build_pasinit

call src_insall %srcdir% %libname%

call src_pas %srcdir% %libname%_angle %1
call src_pas %srcdir% %libname%_byteval %1
call src_pas %srcdir% %libname%_ihs %1
call src_pas %srcdir% %libname%_ipolate %1
call src_pas %srcdir% %libname%_ipolate3 %1
call src_pas %srcdir% %libname%_log %1
call src_pas %srcdir% %libname%_rand %1
call src_pas %srcdir% %libname%_rand_init %1
call src_pas %srcdir% %libname%_sf4 %1
call src_pas %srcdir% %libname%_sf6 %1
call src_pas %srcdir% %libname%_sf8 %1
call src_pas %srcdir% %libname%_sign_int %1
call src_pas %srcdir% %libname%_simul %1
call src_pas %srcdir% %libname%_sinc %1

call src_lib %srcdir% %libname%
call src_msg %srcdir% %libname%
