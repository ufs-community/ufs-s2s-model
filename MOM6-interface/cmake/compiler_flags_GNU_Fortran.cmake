# GNU Fortan

set(CMAKE_Fortran_FLAGS "-g -fbacktrace")

set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -fdefault-real-8 -fdefault-double-8")
set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -Waliasing -fcray-pointer -fconvert=big-endian -ffree-line-length-none -fno-range-check -fbacktrace")

set(CMAKE_Fortran_FLAGS_RELEASE "-O2")

set(CMAKE_Fortran_FLAGS_DEBUG "-O0 -fcheck=bounds -ffpe-trap=invalid,zero,overflow,underflow" )

set(CMAKE_Fortran_LINK_FLAGS "")
