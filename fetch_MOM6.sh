#!/bin/bash
# This script check out MOM6 and related components via github
# Note MOM6 is pointed to NCEP_MOM6 branch
# Note all other components are pointed to their specific commit #

PWD=`pwd`
echo "fetching MOM6 code to $PWD"

#if [ -d MOM_CAP ]; then
# echo "MOM_CAP directory exist, you may have downloaded it already"
# echo "exiting ..."
# exit 8
#fi
#git clone https://github.com/feiliuesmf/nems_mom_cap MOM_CAP

if [ -d MOM6 ]; then
 echo "MOM6 directory exist already"
 echo "exiting ..."
 exit 8
fi

mkdir MOM6
cd MOM6

git clone https://github.com/jiandewang/MOM6_scripts

mkdir src
cp MOM6_scripts/compile.sh .
cd src

git clone https://github.com/NOAA-GFDL/atmos_null
cd atmos_null
git checkout a7b75f3bcb
cd ..

git clone https://github.com/NOAA-GFDL/land_null
cd land_null
git checkout db6837168a 
cd ..

git clone https://github.com/NOAA-GFDL/icebergs
cd icebergs
git checkout 6009017c24
cd ..

git clone https://github.com/NOAA-GFDL/FMS
cd FMS
git checkout 54d1825cfa
cd ..

git clone https://github.com/NOAA-GFDL/coupler
cd coupler
git checkout 71abbf54fb
cd ..

git clone https://github.com/NOAA-GFDL/SIS2
cd SIS2
git checkout be1a91b4f6
cd ..

git clone https://github.com/jiandewang/ice_ocean_extras
git clone https://github.com/jiandewang/mkmf
git clone --recursive -b NCEP_MOM6 https://github.com/jiandewang/MOM6

 
