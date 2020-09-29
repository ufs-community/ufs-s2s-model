list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake)
include(cmeps_compiler_flags)

include("cmeps_files.cmake")

# CMEPS NEMS Utils
add_library(cmeps_util ${cmeps_nems_util_files})

set_target_properties(cmeps_util PROPERTIES ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/CMEPS)
set_target_properties(cmeps_util PROPERTIES Fortran_MODULE_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/CMEPS/mod)
target_include_directories(cmeps_util PUBLIC
                                      $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}/CMEPS/mod>
                                      $<INSTALL_INTERFACE:${CMAKE_INSTALL_PREFIX}/CMEPS/mod>)

target_include_directories(cmeps_util PUBLIC
                                      $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/CMEPS/nems/util>)

target_link_libraries(cmeps_util PUBLIC esmf)
target_link_libraries(cmeps_util PUBLIC PIO::PIO_C PIO::PIO_Fortran)

if(OpenMP_Fortran_FOUND)
  target_link_libraries(cmeps_util PUBLIC OpenMP::OpenMP_Fortran)
endif()

# CMEPS Mediator
add_library(cmeps ${cmeps_mediator_src_files})

set_target_properties(cmeps PROPERTIES ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/CMEPS)
set_target_properties(cmeps PROPERTIES Fortran_MODULE_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/CMEPS/mod)
target_include_directories(cmeps PUBLIC
                                 $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}/CMEPS/mod>
                                 $<INSTALL_INTERFACE:${CMAKE_INSTALL_PREFIX}/CMEPS/mod>)

target_compile_definitions(cmeps PRIVATE
                                 -DESMF_VERSION_MAJOR=${ESMF_VERSION_MAJOR}
                                 -DESMF_VERSION_MINOR=${ESMF_VERSION_MINOR})
target_compile_definitions(cmeps PRIVATE
                                 "-DINTERNAL_PIO_INIT")

target_include_directories(cmeps PUBLIC
                                 $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/CMEPS/mediator>)

target_link_libraries(cmeps PUBLIC cmeps_util)
target_link_libraries(cmeps PUBLIC esmf)
target_link_libraries(cmeps PUBLIC PIO::PIO_C PIO::PIO_Fortran)

if(OpenMP_Fortran_FOUND)
  target_link_libraries(cmeps PUBLIC OpenMP::OpenMP_Fortran)
endif()

###############################################################################
### Install
###############################################################################

install(
  TARGETS cmeps_util cmeps
  EXPORT  cmeps-config
  LIBRARY DESTINATION lib
  ARCHIVE DESTINATION lib
  COMPONENT Library)

install(DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/CMEPS/mod DESTINATION ${CMAKE_INSTALL_PREFIX}/CMEPS)

install(EXPORT      cmeps-config
        DESTINATION lib/cmake)
