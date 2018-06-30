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
