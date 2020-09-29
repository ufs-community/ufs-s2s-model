list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake)
include(cice_compiler_flags)

include("cice_files.cmake")

# Collect source files for library
list(APPEND lib_src_files
  ${cice_shared_files}
  ${cice_shared_files_c}
  ${icepack_files}
  ${cice_mpi_comm_files}
  ${cice_nuopc_cmeps_driver_files}
)

# NetCDF and PIO are both required in CICE
if(NOT NetCDF_Fortran_FOUND OR NOT PIO_Fortran_FOUND)
  message(FATAL_ERROR "NetCDF or PIO required")
else()
  list(APPEND lib_src_files ${cice_netcdf_io_files})
  list(APPEND lib_src_files ${cice_pio2_io_files})
endif()

add_library(cice ${lib_src_files})

set_target_properties(cice PROPERTIES ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/CICE)
set_target_properties(cice PROPERTIES Fortran_MODULE_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/CICE/mod)
target_include_directories(cice PUBLIC
                                $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}/CICE/mod>
                                $<INSTALL_INTERFACE:${CMAKE_INSTALL_PREFIX}/CICE/mod>)

target_compile_definitions(cice PRIVATE
                                "-DFORTRANUNDERSCORE -DUSE_NETCDF")

target_link_libraries(cice PUBLIC esmf)
target_link_libraries(cice PUBLIC NetCDF::NetCDF_Fortran)
target_link_libraries(cice PUBLIC PIO::PIO_Fortran)

if(OpenMP_Fortran_FOUND)
  target_link_libraries(cice PUBLIC OpenMP::OpenMP_Fortran)
endif()

###############################################################################
### Install
###############################################################################

install(
  TARGETS cice
  EXPORT cice-config
  LIBRARY DESTINATION lib
  ARCHIVE DESTINATION lib
  COMPONENT Library)

install(DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/CICE/mod DESTINATION ${CMAKE_INSTALL_PREFIX}/CICE)

install(EXPORT      cice-config
        DESTINATION lib/cmake)
