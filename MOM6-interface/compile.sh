#!/bin/sh

sadness() {
  echo "$@" 1>&2
  exit 8
}

# download MOM6 code
# git clone --recursive https://github.com/NOAA-GFDL/MOM6-examples.git MOM6-examples
#
while [[ "$#" > 0 ]] ; do
    if [[ "$1" == "--fms-dir" ]] ; then
        FMS_DIR=$2
        shift
    elif [[ "$1" == "--platform" ]] ; then
        platform="$2"
        shift
    elif [[ "$1" == "--" ]] ; then
        shift
        break
    fi
    shift
done

if [[ "${FMS_DIR:-Q}" == Q ]] ; then
    export FMS_DIR=$( cd ../FMS/FMS_INSTALL ; pwd -P )
fi

if [[ "${platform:-Q}" == Q ]] ; then
    sadness "Please provide --platform"
fi

if [[ -d "$FMS_DIR" ]] ; then
    echo "Will use FMS from: $FMS_DIR"
else
    sadness "NO FMS!!  Set FMS_DIR variable or use --fms-dir"
fi

set -xue

BASEDIR=`pwd`
MACHINE_ID=${platform}
COMPILE_OPTION=${MACHINE_ID}-intel.mk

# Build in debug mode. If DEBUG=Y, enable DEBUG compilation.
# Otherwise, default to REPRO compilation. This flag is
# set in ${ROOTDIR}/coupledFV3_MOM6_CICE_debug.appBuilder file.
DEBUG=${DEBUG:-}
REPRO=${REPRO:-}
if [[ ${DEBUG} == "Y" ]] ; then
  DEBUG=1
else
  REPRO=1
fi
echo "MOM6 compile.sh ... DEBUG=${DEBUG}, REPRO=${REPRO}"

compile_MOM6_LIB=1
compile_ocean_only=0
compile_MOM6_SIS2=0
###############################################
if [[ ${compile_MOM6_LIB} == 1 ]] ; then
    echo "compile MOM6 library ..."
    cd $BASEDIR
    mkdir -p build/intel/MOM6_LIB/repro
    cd build/intel/MOM6_LIB/repro
    if [[ -f path_names ]] ; then
        rm -f path_names
    fi

    echo "generating file_paths ..."
    $BASEDIR/mkmf/bin/list_paths $BASEDIR/MOM6/src/*/ \
                                 $BASEDIR/MOM6/src/*/*/ \
                                 $BASEDIR/MOM6/config_src/dynamic/ \
                                 $BASEDIR/MOM6/config_src/nuopc_driver/{mom_ocean_model_nuopc.F90,mom_surface_forcing_nuopc.F90}

    echo "generating makefile ..."
    $BASEDIR/mkmf/bin/mkmf -t $BASEDIR/mkmf/templates/${COMPILE_OPTION} -p lib_ocean.a -o "-I${FMS_DIR}" path_names

    echo "compiling MOM6 library..."
    if ( ! make NETCDF=4 REPRO=${REPRO} DEBUG=${DEBUG} lib_ocean.a  ) ; then
        sadness "compiling MOM6 failed"
    fi
    echo "compiling MOM6 library successful"

    # ar rv lib_ocean.a *o
    echo "compiling MOM6 library done"

    # Install library and module files for NEMSAppbuilder
    cd $BASEDIR
    mkdir -p exec/${MACHINE_ID}/
    # link to the library and module files
    ln -s ${BASEDIR}/build/intel/MOM6_LIB/repro exec/${MACHINE_ID}/lib_ocean

fi

###############################################
if [[ ${compile_ocean_only} == 1 ]] ; then
    echo "compile ocean only ..."
    cd $BASEDIR
    mkdir -p build/intel/ocean_only/repro
    cd build/intel/ocean_only/repro
    if [[ -f path_names ]] ; then
        rm -f path_names
    fi

    echo "generating file_paths ..."
    $BASEDIR/mkmf/bin/list_paths ./ \
                                 $BASEDIR/MOM6/{config_src/dynamic,pkg/CVMix-src/src/shared,config_src/solo_driver,src/{*,*/*}}

    echo "generating makefile ..."
    $BASEDIR/mkmf/bin/mkmf -t $BASEDIR/mkmf/templates/${COMPILE_OPTION} -o "-I../../shared/repro -I${FMS_DIR}" -p "MOM6 -L${FMS_DIR} -L../../shared/repro  -lfms" -c "-Duse_libMPI -Duse_netcdf -DSPMD" path_names

    echo "compiling MOM6 ocean only ..."
    if ( ! make NETCDF=4 REPRO=1 MOM6 -j ) ; then
        sadness "compiling Ocean_only exectuable failed"
    fi
    echo "compiling Ocean_only exectuable successful"

    # echo "generating libocean.a"
    # ar rv libocean.a *o

fi
echo "=================================================="

#######################################
if [[ ${compile_MOM6_SIS2} == 1 ]] ; then
    echo "compiling MOM6-SIS2 ..."
    cd $BASEDIR
    mkdir -p build/intel/ice_ocean_SIS2/repro
    cd build/intel/ice_ocean_SIS2/repro
    if [[ -f path_names ]] ; then
        rm -f path_names
    fi

    echo "generating file_paths ..."
    $BASEDIR/mkmf/bin/list_paths ./ \
                                 $BASEDIR/MOM6/config_src/{dynamic,coupled_driver} \
                                 $BASEDIR/MOM6/src/{*,*/*}/ \
                                 $BASEDIR/{atmos_null,coupler,land_null,ice_ocean_extras,icebergs,SIS2,FMS/coupler,FMS/include}

    echo "generating makefile ..."
    $BASEDIR/mkmf/bin/mkmf -t $BASEDIR/mkmf/templates/${COMPILE_OPTION} -o '-I../../shared/repro' -p MOM6 -l '-L../../shared/repro  -lfms' -c '-Duse_libMPI -Duse_netcdf -DSPMD -DUSE_LOG_DIAG_FIELD_INFO -Duse_AM3_physics -D_USE_LEGACY_LAND_' path_names

    echo "compiling MOM6 ocean only ..."
    if ( ! make NETCDF=4 REPRO=1 MOM6 -j ) ; then
        sadness "compiling MOM6-SIS2 exectuable/lib failed" 1>&2
    fi
    echo "compiling MOM6-SIS2 exectuable/lib successful"

    echo "generating lib_ocean.a"
    rm repro
    ar rv lib_ocean.a *o

    echo "compiling MOM6-SIS2 done"

    # Install library and module files for NEMSAppbuilder
    cd $BASEDIR
    mkdir -p exec/${MACHINE_ID}/
    # link to the library and module files
    rm -rf exec/${MACHINE_ID}/lib_FMS exec/${MACHINE_ID}/lib_ocean
    ln -s ${BASEDIR}/build/intel/shared/repro exec/${MACHINE_ID}/lib_FMS
    ln -s ${BASEDIR}/build/intel/ice_ocean_SIS2/repro exec/${MACHINE_ID}/lib_ocean

fi

echo "Next recommended step is to rejoice out of happiness from a successful compile."
