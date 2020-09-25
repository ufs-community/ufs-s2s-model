# Intel C

set( CMAKE_C_FLAGS "-g -traceback")

set( CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -xHOST")

set( CMAKE_C_FLAGS_RELEASE "-O2 -fp-model precise")

set( CMAKE_C_FLAGS_DEBUG "-O0 -ftrapuv")

set( CMAKE_C_LINK_FLAGS "")
