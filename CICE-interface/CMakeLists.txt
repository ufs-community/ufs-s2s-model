include(GNUInstallDirs)

include("cice_files.cmake")

list(APPEND comm_list ${cice_mpi_comm_files})
list(APPEND driver_list ${cice_nuopc_cmeps_driver_files})


# Collect IO files for appropriate IO
if(NetCDF_Fortran_FOUND)
  message(STATUS "CICE: Build with NetCDF IO")
  list(APPEND io_list ${cice_netcdf_io_files})
elseif(PIO_Fortran_FOUND)
  message(STATUS "CICE: Build with Parallel IO")
  list(APPEND io_list ${cice_pio2_io_files})
else()
  message(FATAL_ERROR "NetCDF or PIO required")
#  message(STATUS "CICE: Build with Binary IO")
#  list(APPEND io_list ${cice_binary_io_files})
endif()

# Merge all the lists together for the library
list(APPEND lib_src_files
  ${cice_shared_files}
  ${cice_shared_files_c}
  ${icepack_files}
  ${comm_list}
  ${io_list}
  ${driver_list}
)

set(libName "cice")
set(moduleDir "${CMAKE_CURRENT_BINARY_DIR}/mod")

add_library(${libName} STATIC ${lib_src_files})
add_library(${libName}::${libName} ALIAS ${libName})


#set_target_properties(${libName} PROPERTIES COMPILE_FLAGS "-fp-model precise -convert big_endian -traceback -xHost -FR")

target_link_libraries(${libName} PUBLIC cmeps)
target_link_libraries(${libName} PUBLIC esmf MPI::MPI_Fortran)
if(NetCDF_Fortran_FOUND)
  target_link_libraries(${libName} PUBLIC NetCDF::NetCDF_Fortran)
elseif(PIO_Fortran_FOUND)
  target_link_libraries(${libName} PUBLIC PIO::PIO_Fortran PIO::PIO_C)
endif()

target_compile_definitions(${libName} PRIVATE -DESMF_VERSION_MAJOR=${ESMF_VERSION_MAJOR}
					      -DESMF_VERSION_MINOR=${ESMF_VERSION_MINOR})
target_compile_definitions(${libName} PRIVATE "-DFORTRANUNDERSCORE -Dcoupled -DUSE_NETCDF")
target_include_directories(${libName} PRIVATE ${ESMF_MOD})

target_include_directories(${libName} PUBLIC $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/CICE/cicecore/drivers/nuopc/cmeps>
                                             $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/CICE/cicecore/cicedynB/dynamics>
                                             $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/CICE/cicecore/cicedynB/general>
                                             $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/CICE/cicecore/cicedynB/analysis>
                                             $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/CICE/cicecore/cicedynB/infrastructure>
                                             $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/CICE/cicecore/cicedynB/infrastructure/io/io_netcdf>
                                             $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/CICE/cicecore/cicedynB/infrastructure/comm/mpi>
                                             $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/CICE/cicecore/shared>
                                             $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/CICE/icepack/columnphysics>
)



if(OPENMP)
  target_link_libraries(${libName} PUBLIC OpenMP::OpenMP_Fortran)
  set(ENV{ICE_THREADED} true)
else()
  set(ENV{ICE_THREADED} false)
endif()

set_target_properties(${libName} PROPERTIES Fortran_MODULE_DIRECTORY ${moduleDir})
target_include_directories(${libName} INTERFACE
  $<BUILD_INTERFACE:${moduleDir}>
  $<INSTALL_INTERFACE:include/${libName}>)

# Install library
install(
  TARGETS ${libName}
  LIBRARY DESTINATION lib
  ARCHIVE DESTINATION lib
  COMPONENT Library)
# Install compiled Fortran modules
install(DIRECTORY ${moduleDir} DESTINATION ${CMAKE_INSTALL_PREFIX})
