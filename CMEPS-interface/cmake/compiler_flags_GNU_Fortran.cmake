# GNU Fortan

set(CMAKE_Fortran_FLAGS "-g -fbacktrace -ffree-line-length-none")

set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS}")

set(CMAKE_Fortran_FLAGS_RELEASE "-O2")

set(CMAKE_Fortran_FLAGS_DEBUG "-O0 -fcheck=bounds -ffpe-trap=invalid,zero,overflow,underflow" )

set(CMAKE_Fortran_LINK_FLAGS "")
