if(32BIT)
  message(FATAL_ERROR "MOM6 demands double precision, ABORT!")
endif()

if(OPENMP)
  message(FATAL_ERROR "MOM6 does not build with OpenMP threading, ABORT!")
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

install(EXPORT      ${libName}-config
        DESTINATION lib/cmake)
