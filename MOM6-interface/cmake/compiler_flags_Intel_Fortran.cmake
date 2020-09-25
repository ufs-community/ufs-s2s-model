# Intel Fortan

set(CMAKE_Fortran_FLAGS "-g -traceback")

set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -i4 -r8")
set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -fno-alias -auto -safe-cray-ptr -ftz -assume byterecl -sox")

set(CMAKE_Fortran_FLAGS_RELEASE "-O2 -fp-model source -debug minimal -nowarn")

set(CMAKE_Fortran_FLAGS_DEBUG "-O0 -check -check noarg_temp_created -check nopointer -warn -warn noerrors -fpe0 -ftrapuv")

set(CMAKE_Fortran_LINK_FLAGS "")
