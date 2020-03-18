FV3-MOM6-CICE5 Compset Data Fingerprint File
=============================================

This file documents the compset input and baseline data stored
outside the repository.  It also serves as a verification method 
to ensure the data directory in use matches the one desired by 
this version of the application. Therefore, anytime there is an 
update to the compset inputs or baseline data, this file needs 
to be updated in the data storage area and in the repository.  


Compset Data Description
--------------------------------

Created for application: FV3-MOM6-CICE5

Change log:

* Feb. 26, 2018 - FV3 ICs and test baselines are from RT/NEMSfv3gfs/trunk-20171016
                  MOM6 ICs and input are for 1/4 deg
                  CICE5 ICs and input are for 1/4 deg
* Mar. 13, 2018 - Moving updateMOM6CICE to master 
* Mar. 19, 2018 - Updated CICE/ice_in and added MEDIATOR dir which has restart files
                  for the mediator
* Apr. 18, 2018 - Update FV3 ICs and inputs from RT/NEMSfv3gfs/trunk-20180330
* May  21, 2018 - Created a combined diag_table for ATM and MOM6 output
* Jun  6,  2018 - Created a new test "cpld_fv3_mom6_cice_2d" to run the model for 2 days. 
                  In this new test, the FV3 history files are written on the Gaussian grid.
* Jun. 20, 2018 - Add restart capability for CICE (now included in warm-start) and
                  updated the CICE grid with a fix for a point near the pole
* Jun  25, 2018 - Updated diag_table so that the output frequency from MOM6 is every three hours. 
                  The NSSTM is off. The near sea surface temperature model is not used.
* Jul  27, 2018 - Coupling fields from CICE5 are used in FV3.
* Aug. 16, 2018 - Update MOM6 and its input files.
* Aug. 20, 2018 - Update FV3.
* Sep.  4, 2018 - CICE grid updated FV3 basline updated after FV3 updated (RT/NEMSfv3gfs/trunk-20180829)
* Oct. 13, 2018 - Revised "regression test description" in compsets/fv3mom6cice5.input.
* Oct. 18, 2018 - Prep for benchmark
* Dec  20, 2018 - Updating mediator files (FV3 results change with update of code) 
* Mar. 11, 2019 - Updating inputs for MOM6 and CICE5 to be templates and updated baselines
                  and created new baselines for updated code
* Apr. 10, 2019 - Updating timesteps, new MEDIATOR files needed
* Jun. 18, 2019 - Updating FV3 and MOM6 to their masters. MOM6 corresponds to GFDL dev/master 20190422.
* Aug. 11, 2019 - Creating branch "update_fv3_0606" using the following submodules: 
                  b4ea027ce55b6d0aa16d863932c94f7f3b913d0e CICE_SRC (remotes/origin/feature/nems_sea_ice-6-gb4ea027)
                  d4937c8aeb927f0ff33fc59845da386502350d16 FMS (warsaw_201803-11-gd4937c8)
                  a58e43eb09c525c45fdfc620addad2fe88028fae FV3 (NEMSfv3gfs_preCCPP_20190506-4-ga58e43e)
                  a1f5b75b06d1e5c275039600b876b467cffbf0fd MOM6 (NEMSMOM6_20190306)
                  be73d771cdf7352ab2aa32fcf004bcb9666b43e1 NEMS (be73d77) - Apr 6, 2019 
                  (be73d77 is the same as c1c570160f327dff957764b0dce058d7361febed - Apr 6, 2019)
* Sep. 14, 2019 - Creating branch "update_fv3_09"
* Sep. 23, 2019 - Porting to Hera has been done. Currently this application only works on Hera. 
                  New master branch is created with the following submodules:
                  fad26550abab181ceadfe687fd99acf175e91d33 CICE_SRC (heads/develop)
                  32c2c2c6ccdf1295fb80c3008af3f1919a356c9f FMS (warsaw_201803-112-g32c2c2c)
                  b67d9a398bc2fb2b76701711a6b33eb925a8c7e6 FV3 (NEMSfv3gfs_preCCPP_20190506-13-gb67d9a3)
                  862cba89c30e061723e9e077a8b59af7069435f4 MOM6 (NEMSMOM6_20190306-8-g862cba8)
                  e05bf2a554544093f02bf177658ad432cbafbaa8 NEMS (heads/develop)
                  a40d93c0dd92933a0d4ed2f62759433384456c3f stochastic_physics (heads/master)
* Oct. 7, 2019    New master branch is created with the following submodules:
                  fad2655 CICE_SRC (heads/develop)
                  558d8d9 FMS (warsaw_201803-15-g558d8d9)
                  f4f8644 FV3 (NEMSfv3gfs_preCCPP_20190506-15-gf4f8644)
                  c0394b7 MOM6 (NEMSMOM6_20190306-9-gc0394b7)
                  ba1ddf7 NEMS (heads/develop)
                  257252e ccpp/framework (ccpp_transition_to_vlab_master_20190705-68-g257252e)
                  ce641c9 ccpp/physics (ccpp_transition_to_vlab_master_20190705-101-gce641c9)
                  a40d93c stochastic_physics (a40d93c)
* Oct. 25, 2019    New master branch is created with the following submodules:
                  fad2655 CICE_SRC (heads/develop)
                  46014b4 FMS (warsaw_201803-17-g46014b4)
                  a31f0bb FV3 (heads/develop).FV3 points to fv3atm repository.
                  c0394b7 MOM6 (NEMSMOM6_20190306-9-gc0394b7)
                  8cb7137 NEMS (heads/develop)
                  257252e ccpp/framework (ccpp_transition_to_vlab_master_20190705-68-g257252e)
                  ce641c9 ccpp/physics (ccpp_transition_to_vlab_master_20190705-101-gce641c9)
                  a40d93c stochastic_physics (a40d93c)
* Nov. 6, 2019    New master branch is created with the following submodules:
                  fad2655 CICE_SRC (heads/develop)
                  46014b4 FMS (warsaw_201803-17-g46014b4)
                  45dbc34 FV3 (heads/develop), ccpp is under FV3 directory.
                  660cb1c MOM6 (heads/develop)
                  22be22b NEMS (heads/develop)
                  25c3321 stochastic_physics (heads/master)
* Nov. 20, 2019   FV3_input_data was synced with NEMSfv3gfs/trunk-20191109/FV3_input_data
                  Input templates were removed and fix file directories were cleaned up 
* Jan. 28, 2020   FV3 ensures imported ice_fraction is in range (0-1), merges between
                  ice and ocean in prep_atm phase of mediator are removed
* Feb. 27, 2020   Field name changes for CICE SW, removal of custom merges in prep_atm, removal
                  of mediator fluxes for icy water in prep_ocn
