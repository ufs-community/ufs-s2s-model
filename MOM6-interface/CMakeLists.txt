include(GNUInstallDirs)

if(32BIT)
remove_definitions(-DOVERLOAD_R4)
remove_definitions(-DOVERLOAD_R8)
message (WARNING "MOM6 does not compile on 32bit, forcing 64 bits")
if(CMAKE_Fortran_COMPILER_ID MATCHES "Intel")
    if(REPRO)
        string (REPLACE "-i4 -real-size 32" "-i4 -real-size 64" CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS}")
    else()
        string (REPLACE "-i4 -real-size 32" "-i4 -real-size 64 -no-prec-div -no-prec-sqrt" CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS}")
    endif()
elseif(CMAKE_Fortran_COMPILER_ID MATCHES "GNU")
    set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -fdefault-real-8")
endif()
endif()

if(CMAKE_Fortran_COMPILER_ID MATCHES "Intel")
    string (REPLACE "-assume realloc_lhs" " " CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS}")
    set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -Wp,-w -r8 -traceback")
endif()

if(OPENMP)
  message(WARNING "MOM6 CANNOT BE BUILT WITH OPENMP.. DISABLING")
  #CMAKE_Fortran_FLAGS
  string(REPLACE " " ";" CMAKE_Fortran_FLAGS ${CMAKE_Fortran_FLAGS})
  list(REMOVE_ITEM CMAKE_Fortran_FLAGS "-qopenmp")
  string(REPLACE ";" " " CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS}")
  #CMAKE_C_FLAGS
  string(REPLACE " " ";" CMAKE_C_FLAGS ${CMAKE_C_FLAGS})
  list(REMOVE_ITEM CMAKE_C_FLAGS "-qopenmp")
  string(REPLACE ";" " " CMAKE_C_FLAGS "${CMAKE_C_FLAGS}")
  #CMAKE_EXE_LINKER_FLAGS
  string(REPLACE " " ";" CMAKE_EXE_LINKER_FLAGS ${CMAKE_EXE_LINKER_FLAGS})
  list(REMOVE_ITEM CMAKE_EXE_LINKER_FLAGS "-qopenmp")
  string(REPLACE ";" " " CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS}")
endif()

include("mom6_files.cmake")

list(APPEND lib1_src_files
  ${ocean_src_files}
  ${ocean_config_src_files})

#########################
### ocean
########################

set(lib1Name "ocean")
set(moduleDir "${CMAKE_CURRENT_BINARY_DIR}/mod")

add_library(${lib1Name} STATIC ${lib1_src_files})
add_library(${lib1Name}::${lib1Name} ALIAS ${lib1Name})

set_target_properties(${lib1Name} PROPERTIES Fortran_MODULE_DIRECTORY ${moduleDir})
target_include_directories(${lib1Name} PUBLIC $<BUILD_INTERFACE:${moduleDir}>)

target_include_directories(${lib1Name} PUBLIC
  $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/MOM6/config_src/dynamic>
  $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/MOM6/src/framework>
  $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/MOM6/config_src/nuopc_driver>)

target_include_directories(${lib1Name} INTERFACE
  $<BUILD_INTERFACE:${moduleDir}>
  $<INSTALL_INTERFACE:include/${lib1Name}>)

target_link_libraries(${lib1Name} PUBLIC fms)
target_link_libraries(${lib1Name} PUBLIC NetCDF::NetCDF_Fortran)

#########################
### mom6
########################
set(libName "mom6")

list(APPEND lib_src_files
  ${mom_config_src_files})

add_library(${libName} STATIC ${lib_src_files})
add_library(${libName}::${libName} ALIAS ${libName})

set_target_properties(${libName} PROPERTIES Fortran_MODULE_DIRECTORY ${moduleDir})
target_include_directories(${libName} PUBLIC $<BUILD_INTERFACE:${moduleDir}>)

target_compile_definitions(${libName} PRIVATE -DMOM6_CAP)
target_compile_definitions(${libName} PRIVATE -DESMF_NO_INTEGER_1_BYTE
					      -DESMF_NO_INTEGER_2_BYTE
					      -DESMF_MOAB=1
					      -DESMF_LAPACK=1
					      -DESMF_LAPACK_INTERNAL=1
					      -DESMF_NO_ACC_SOFTWARE_STACK=1
					      -DESMF_NETCDF=1
					      -DESMF_YAMLCPP=1
					      -DESMF_YAML=1
					      -DESMF_PIO=1
					      -DESMF_MPIIO
					      -DESMF_NO_OPENACC
					      -DESMF_BOPT_O
					      -DESMF_TESTCOMPTUNNEL
					      -DSx86_64_small=1
					      -DESMF_OS_Linux=1
					      -DESMF_COMM=intelmpi)
target_link_libraries(${libName} PUBLIC ${lib1Name})
target_link_libraries(${libName} PUBLIC esmf)

#########################
### Install
#########################

# Install library
install(
  TARGETS ${libName} ${lib1Name}
  EXPORT ${libName}-config
  LIBRARY DESTINATION lib
  ARCHIVE DESTINATION lib
  COMPONENT Library)
install(DIRECTORY ${moduleDir} DESTINATION ${CMAKE_INSTALL_PREFIX})

install(EXPORT ${libName}-config
  DESTINATION lib/cmake
)
