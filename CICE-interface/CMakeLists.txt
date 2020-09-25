f(CMAKE_Fortran_COMPILER_ID MATCHES "Intel")
    string (REPLACE "-fp-model source" "-fp-model precise" CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS}")
    string (REPLACE "-xCORE-AVX2" "-xHost" CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS}")
    set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -convert big_endian -traceback -FR")
endif()

include("cice_files.cmake")

# Collect source files for library
list(APPEND lib_src_files
  ${cice_shared_files}
  ${cice_shared_files_c}
  ${icepack_files}
  ${cice_mpi_comm_files}
  ${cice_nuopc_cmeps_driver_files}
)

# NetCDF or PIO is required in CICE
if(NOT NetCDF_Fortran_FOUND AND NOT PIO_Fortran_FOUND)
  message(FATAL_ERROR "NetCDF or PIO required")
#  message(STATUS "CICE: Build with Binary IO")
#  list(APPEND io_list ${cice_binary_io_files})
else()
  if(NetCDF_Fortran_FOUND)
    message(STATUS "CICE: Build with NetCDF IO")
    list(APPEND lib_src_files ${cice_netcdf_io_files})
  endif()
  if(PIO_Fortran_FOUND)
    message(STATUS "CICE: Build with Parallel IO")
    list(APPEND lib_src_files ${cice_pio2_io_files})
  endif()
endif()

add_library(cice ${lib_src_files})

set_target_properties(cice PROPERTIES Fortran_MODULE_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/CICE/mod)
target_include_directories(cice PUBLIC
                                $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}/CICE/mod>
                                $<INSTALL_INTERFACE:${CMAKE_INSTALL_PREFIX}/CICE/mod>)

target_compile_definitions(cice PRIVATE
                                "-DFORTRANUNDERSCORE -DUSE_NETCDF")

# Where in CICE are the following used?
#target_compile_definitions(cice PRIVATE
#                                "-Dcoupled")
#target_compile_definitions(cice PRIVATE
#                                -DESMF_VERSION_MAJOR=${ESMF_VERSION_MAJOR}
#					                      -DESMF_VERSION_MINOR=${ESMF_VERSION_MINOR})

# target_link_libraries(cice PUBLIC cmeps) # Is CMEPS needed in CICE, Really?
target_link_libraries(cice PUBLIC esmf)

if(NetCDF_Fortran_FOUND)
  target_link_libraries(cice PUBLIC NetCDF::NetCDF_Fortran)
endif()

if(PIO_Fortran_FOUND)
  target_link_libraries(cice PUBLIC PIO::PIO_Fortran)
endif()

if(OpenMP_Fortran_FOUND)
  target_link_libraries(cice PUBLIC OpenMP::OpenMP_Fortran)
endif()

target_include_directories(cice INTERFACE
                                $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}/CICE/mod>
                                $<INSTALL_INTERFACE:${CMAKE_INSTALL_PREFIX}/CICE/mod>)

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
