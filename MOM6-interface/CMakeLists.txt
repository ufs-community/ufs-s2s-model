include(GNUInstallDirs)

include("mom6_files.cmake")

list(APPEND lib_src_files
  ${mom6_src_files}
  ${mom6_config_src_files})

set(libName "nuopcmom6")
set(moduleDir "${CMAKE_CURRENT_BINARY_DIR}/mod")

add_library(${libName} STATIC ${lib_src_files})
add_library(${libName}::${libName} ALIAS ${libName})

set_target_properties(${libName} PROPERTIES Fortran_MODULE_DIRECTORY ${moduleDir})
target_include_directories(${libName} PUBLIC $<BUILD_INTERFACE:${moduleDir}>)

target_compile_definitions(${libName} PRIVATE -DESMF_VERSION_MAJOR=${ESMF_VERSION_MAJOR})
target_compile_definitions(${libName} PRIVATE -DMOM6_CAP)
target_include_directories(${libName} PRIVATE ${ESMF_MOD})


target_include_directories(${libName} PUBLIC
  $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/MOM6/config_src/dynamic>
  $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/MOM6/src/framework>
  $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/MOM6/config_src/nuopc_driver>)

target_include_directories(${libName} INTERFACE
  $<BUILD_INTERFACE:${moduleDir}>
  $<INSTALL_INTERFACE:include/${libName}>)

target_link_libraries(${libName} PUBLIC fms)
target_link_libraries(${libName} PUBLIC NetCDF::NetCDF_Fortran)
target_link_libraries(${libName} PUBLIC esmf)
if(OpenMP)
  target_link_libraries(${libName} PUBLIC OpenMP::OpenMP_Fortran)
endif()

#########################
### Install
#########################


# Install library
install(
  TARGETS ${libName}
  LIBRARY DESTINATION lib
  ARCHIVE DESTINATION lib
  COMPONENT Library)
install(DIRECTORY ${moduleDir} DESTINATION ${CMAKE_INSTALL_PREFIX})
