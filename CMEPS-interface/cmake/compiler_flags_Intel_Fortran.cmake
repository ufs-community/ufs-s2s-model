# Intel Fortan

set(CMAKE_Fortran_FLAGS "-g -traceback")

set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -O -assume realloc_lhs")

set(CMAKE_Fortran_FLAGS_RELEASE "-O2 -fp-model precise")

set(CMAKE_Fortran_FLAGS_DEBUG "-O0 -check -check noarg_temp_created -check nopointer -warn -warn noerrors -fpe0 -ftrapuv")

set(CMAKE_Fortran_LINK_FLAGS "")
