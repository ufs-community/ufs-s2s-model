#!/bin/bash
set -eux

SECONDS=0

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 app_name [ build_nr ] [ clean_before ] [ clean_after ]"
  exit 1
fi

readonly app_name=$1
readonly build_name=fv3_mom6_cice_${2:-0}
readonly clean_before=${3:-YES}
readonly clean_after=${4:-YES}

hostname

readonly compile_root_dir=$(cd "$(dirname "$0")" && pwd -P )
PATHTR=${PATHTR:-$(cd ${compile_root_dir}/.. && pwd)}
echo "PATHTR is $PATHTR"
cd ${PATHTR}/NEMS

if [[ ${clean_before} == YES ]]; then
  make app=${app_name} distclean
fi

make app=${app_name} build

if [[ ${clean_after} == YES ]]; then
  make app=${app_name} clean
fi

cp ${PATHTR}/NEMS/exe/NEMS.x ${PATHTR}/tests/${build_name}.exe
cp ${PATHTR}/NEMS/src/conf/modules.nems ${PATHTR}/tests/modules.${build_name}

elapsed=$SECONDS
echo "Elapsed time $elapsed seconds. Compiling ${app_name} finished"
