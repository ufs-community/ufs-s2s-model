
if(CMAKE_Fortran_COMPILER_ID MATCHES "Intel")
  string (REPLACE "-assume byterecl" "-assume realloc_lhs" CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS}")
  set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -m64 -mcmodel=small")
endif()

include(cmeps_files.cmake)
add_library(cmeps ${cmeps_src_files})

target_include_directories(cmeps PUBLIC $<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/CMEPS/mediator>
                                        $<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/CMEPS/nems/util>)

target_link_libraries(cmeps PUBLIC PIO::PIO_C PIO::PIO_Fortran)
target_link_libraries(cmeps PUBLIC esmf)

target_compile_definitions(cmeps PRIVATE -DESMF_VERSION_MAJOR=${ESMF_VERSION_MAJOR}
                                         -DESMF_VERSION_MINOR=${ESMF_VERSION_MINOR})

target_compile_definitions(cmeps PRIVATE "-DINTERNAL_PIO_INIT")

set_target_properties(cmeps PROPERTIES ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/CMEPS)
set_target_properties(cmeps PROPERTIES Fortran_MODULE_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/CMEPS/mod)
target_include_directories(cmeps PUBLIC $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}/CMEPS/mod>
                                        $<INSTALL_INTERFACE:${CMAKE_INSTALL_PREFIX}/CMEPS/mod>)

# Install library
install(
  TARGETS cmeps
  EXPORT  cmeps-config
  LIBRARY DESTINATION lib
  ARCHIVE DESTINATION lib
  COMPONENT Library)

install(DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/CMEPS/mod DESTINATION ${CMAKE_INSTALL_PREFIX}/CMEPS)

install(EXPORT      cmeps-config
        DESTINATION lib/cmake)
