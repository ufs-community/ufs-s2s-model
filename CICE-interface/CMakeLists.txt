include(GNUInstallDirs)

include("cice_files.cmake")

# Configuration Options
set(CICE_DRIVER "NUOPC" CACHE STRING "CICE OPTIONS: Choose CICE6 Driver." FORCE)
set_property(CACHE CICE_DRIVER PROPERTY STRINGS "STANDALONE" "NUOPC" "DIRECT" "MCT")

set(NUOPC_TARGET "CMEPS" CACHE STRING "CICE OPTIONS: Choose NUOPC implementation." FORCE)
set_property(CACHE NUOPC_TARGET PROPERTY STRINGS "CMEPS" "DMI")

message(STATUS "CICE: CICE_DRIVER = ${CICE_DRIVER}")
message(STATUS "CICE: NUOPC_TARGET = ${NUOPC_TARGET}")

# Choose files based on Serial or MPI build
if(MPI_Fortran_FOUND)
  message(STATUS "CICE: Build with MPI")
  list(APPEND comm_list ${cice_mpi_comm_files})
else()
  message(STATUS "CICE: Build without MPI")
  list(APPEND comm_list ${cice_serial_comm_files})
endif()

# Collect IO files for appropriate IO
if(USE_NetCDF AND NetCDF_Fortran_FOUND)
  message(STATUS "CICE: Build with NetCDF IO")
  list(APPEND io_list ${cice_netcdf_io_files})
elseif(USE_PIO AND PIO_Fortran_FOUND)
  message(STATUS "CICE: Build with Parallel IO")
  list(APPEND io_list ${cice_pio2_io_files})
else()
  message(STATUS "CICE: Build with Binary IO")
  list(APPEND io_list ${cice_binary_io_files})
endif()

# Collect driver files
# There are multiple drivers in the drivers area
if(CICE_DRIVER STREQUAL "NUOPC")
  if(NUOPC_TARGET STREQUAL "CMEPS")
    list(APPEND driver_list ${cice_nuopc_cmeps_driver_files})
  elseif(NUOPC_TARGET STREQUAL "DMI")
    list(APPEND driver_list ${cice_nuopc_dmi_driver_files})
  endif()
elseif(CICE_DRIVER STREQUAL "DIRECT")
  list(APPEND driver_list ${cice_direct_driver_files})
elseif(CICE_DRIVER STREQUAL "MCT")
  list(APPEND driver_list ${cice_mct_driver_files})
else()
  list(APPEND driver_list ${cice_standalone_driver_files})
endif()

# Merge all the lists together for the library
list(APPEND lib_src_files
  ${cice_shared_files}
  ${icepack_files}
  ${comm_list}
  ${io_list}
  ${driver_list}
)

set(libName "nuopccice")
set(moduleDir "${CMAKE_CURRENT_BINARY_DIR}/include/${libName}")

add_library(${libName} STATIC ${lib_src_files})
add_library(${libName}::${libName} ALIAS ${libName})

set_target_properties(${libName} PROPERTIES Fortran_MODULE_DIRECTORY
                                            ${moduleDir})

target_compile_definitions(${libName} PRIVATE -DESMF_VERSION_MAJOR=${ESMF_VERSION_MAJOR})
target_include_directories(${libName} PRIVATE ${ESMF_MOD})

if(NetCDF_Fortran_FOUND)
  target_link_libraries(${libName} PUBLIC NetCDF::NetCDF_Fortran)
endif()

if(PIO_Fortran_FOUND)
  target_link_libraries(${libName} PUBLIC PIO::PIO_Fortran)
endif()

target_include_directories(${libName} INTERFACE
  $<BUILD_INTERFACE:${moduleDir}>
  $<INSTALL_INTERFACE:include/${libName}>)

if(OpenMP_Fortran_FOUND)
  target_link_libraries(${libName} PUBLIC OpenMP::OpenMP_Fortran)
endif()

# Install compiled Fortran modules
install(DIRECTORY ${moduleDir} DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})

# Install library
install(
  TARGETS ${libName}
  LIBRARY DESTINATION lib
  ARCHIVE DESTINATION lib
  COMPONENT Library)
