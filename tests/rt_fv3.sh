#!/bin/bash
set -eux

source rt_utils.sh
source atparse.bash
source edit_inputs.sh

mkdir -p ${RUNDIR}
cd $RUNDIR

###############################################################################
# Make configure and run files
###############################################################################

# FV3 executable:
cp ${PATHRT}/$FV3X                                 fcst.exe

# modulefile for FV3 prerequisites:
cp ${PATHRT}/modules.fcst_${COMPILE_NR}             modules.fcst

# Get the shell file that loads the "module" command and purges modules:
cp ${PATHRT}/../NEMS/src/conf/module-setup.sh.inc  module-setup.sh
#cp ${PATHTR}/parm/post_itag itag
#cp ${PATHTR}/parm/postxconfig-NT.txt postxconfig-NT.txt
#cp ${PATHTR}/parm/postxconfig-NT_FH00.txt postxconfig-NT_FH00.txt
#cp ${PATHTR}/parm/params_grib2_tbl_new params_grib2_tbl_new

SRCD="${PATHTR}"
RUND="${RUNDIR}"

# Set up the run directory
atparse < ${PATHRT}/fv3_conf/${FV3_RUN:-fv3_run.IN} > fv3_run
source ./fv3_run
atparse < ${PATHTR}/parm/${INPUT_NML:-input.nml.IN} > input.nml
atparse < ${PATHTR}/parm/${MODEL_CONFIGURE:-model_configure.IN} > model_configure
atparse < ${PATHTR}/parm/${NEMS_CONFIGURE:-nems.configure} > nems.configure

edit_ice_in < ${PATHTR}/parm/ice_in_template > ice_in
edit_mom_input < ${PATHTR}/parm/${MOM_INPUT:-MOM_input_template_$OCNRES} > INPUT/MOM_input
edit_diag_table < ${PATHTR}/parm/diag_table_template > diag_table
edit_data_table < ${PATHTR}/parm/data_table_template > data_table
# CMEPS 
cp ${PATHTR}/parm/fd_nems.yaml fd_nems.yaml
cp ${PATHTR}/parm/pio_in pio_in
cp ${PATHTR}/parm/med_modelio.nml med_modelio.nml

if [[ "Q${INPUT_NEST02_NML:-}" != Q ]] ; then
    atparse < ${PATHTR}/parm/${INPUT_NEST02_NML} > input_nest02.nml
fi

if [[ $SCHEDULER = 'moab' ]]; then
  atparse < $PATHRT/fv3_conf/fv3_msub.IN > job_card
elif [[ $SCHEDULER = 'pbs' ]]; then
  NODES=$(( TASKS / TPN ))
  if (( NODES * TPN < TASKS )); then
    NODES=$(( NODES + 1 ))
  fi
  atparse < $PATHRT/fv3_conf/fv3_qsub.IN > job_card
elif [[ $SCHEDULER = 'sbatch' ]]; then
  NODES=$(( TASKS / TPN ))
  if (( NODES * TPN < TASKS )); then
    NODES=$(( NODES + 1 ))
  fi
  atparse < $PATHRT/fv3_conf/fv3_qsub.IN > job_card
elif [[ $SCHEDULER = 'slurm' ]]; then
  NODES=$(( TASKS / TPN ))
  if (( NODES * TPN < TASKS )); then
    NODES=$(( NODES + 1 ))
  fi
  atparse < $PATHRT/fv3_conf/fv3_slurm.IN > job_card
elif [[ $SCHEDULER = 'lsf' ]]; then
  if (( TASKS < TPN )); then
    TPN=${TASKS}
  fi
  atparse < $PATHRT/fv3_conf/fv3_bsub.IN > job_card
fi

atparse < ${PATHTR}/parm/${NEMS_CONFIGURE:-nems.configure} > nems.configure

################################################################################
# Submit test
################################################################################

if [[ $ROCOTO = 'false' ]]; then
  submit_and_wait job_card
else
  chmod u+x job_card
  ./job_card
fi

check_results

################################################################################
# End test
################################################################################

exit 0
