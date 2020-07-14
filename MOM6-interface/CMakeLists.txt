include(GNUInstallDirs)

include("mom6_files.cmake")

list(APPEND lib_src_files
  ${mom6_src_files}
  ${mom6_config_src_files})

set(libName "nuopcmom6")
set(moduleDir "${CMAKE_CURRENT_BINARY_DIR}/include/${libName}")

add_library(${libName} STATIC ${lib_src_files})
add_library(${libName}::${libName} ALIAS ${libName})

set_target_properties(${libName} PROPERTIES Fortran_MODULE_DIRECTORY
                                            ${moduleDir})

target_compile_definitions(${libName} PRIVATE -DESMF_VERSION_MAJOR=${ESMF_VERSION_MAJOR})
target_include_directories(${libName} PRIVATE ${ESMF_MOD})

target_link_libraries(${libName} PUBLIC FMS::fms_r8
                                        NetCDF::NetCDF_Fortran)

target_include_directories(${libName} PUBLIC
  $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/MOM6/config_src/dynamic>
  $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/MOM6/src/framework>)

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
