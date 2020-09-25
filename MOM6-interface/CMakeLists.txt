if(32BIT)
  message(FATAL_ERROR "MOM6 demands double precision, ABORT!")
endif()

if(OPENMP)
  message(FATAL_ERROR "MOM6 does not build with OpenMP threading, ABORT!")
endif()

include("mom6_files.cmake")

###############################################################################
### mom6
###############################################################################

add_library(mom6 ${mom6_src_files})

set_target_properties(mom6 PROPERTIES Fortran_MODULE_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/MOM6/mod)
target_include_directories(mom6 PUBLIC
                                $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}/MOM6/mod>
                                $<INSTALL_INTERFACE:${CMAKE_INSTALL_PREFIX}/MOM6/mod>)

target_include_directories(mom6 PUBLIC
                                $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/MOM6/config_src/dynamic>
                                $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/MOM6/src/framework>
                                $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/MOM6/config_src/nuopc_driver>)

target_link_libraries(mom6 PUBLIC fms)
target_link_libraries(mom6 PUBLIC NetCDF::NetCDF_Fortran)

target_include_directories(mom6 INTERFACE
                                $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}/MOM6/mod>
                                $<INSTALL_INTERFACE:${CMAKE_INSTALL_PREFIX}/MOM6/mod>)

###############################################################################
### mom6ocn
###############################################################################

add_library(mom6ocn ${mom6_config_src_files})

set_target_properties(mom6ocn PROPERTIES Fortran_MODULE_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/MOM6/mod)
target_include_directories(mom6ocn PUBLIC
                                   $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}/MOM6/mod>
                                   $<INSTALL_INTERFACE:${CMAKE_INSTALL_PREFIX}/MOM6/mod>)

target_link_libraries(mom6ocn PUBLIC mom6)
target_link_libraries(mom6ocn PUBLIC esmf)

target_include_directories(mom6ocn INTERFACE
                                   $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}/MOM6/mod>
                                   $<INSTALL_INTERFACE:${CMAKE_INSTALL_PREFIX}/MOM6/mod>)

###############################################################################
### Install
###############################################################################

install(
  TARGETS mom6ocn mom6
  EXPORT mom6ocn-config
  LIBRARY DESTINATION lib
  ARCHIVE DESTINATION lib
  COMPONENT Library)

install(DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/MOM6/mod DESTINATION ${CMAKE_INSTALL_PREFIX}/MOM6)

install(EXPORT      mom6ocn-config
        DESTINATION lib/cmake)
