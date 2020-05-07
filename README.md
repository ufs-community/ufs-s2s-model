# UFS-S2S-MODEL

# Where to find information

Start at the ufs-s2s-model wiki (https://github.com/ufs-community/ufs-s2s-model/wiki) which has more detailed information.

# The directory structure:

| File/directory    | Purpose |
| --------------    | ------- |
| ```LICENSE.md```  | A copy of the Gnu general public license, version 3. |
| ```CICE_SRC```    | Source code for CICE5. |
| ```CICE```        | Soft link to CICE_SRC/lanl_cice (CICE5 source code). |
| ```CICE_CAP```    | Soft link to CICE_SRC/lanl_cice_cap (CICE5 cap code). |
| ```compsets```    | Files used for setting up regression test suite. |
| ```conf```        | Configuration files used for compiling code on various computer systems. |
| ```coupledFV3_MOM6_CICE.appBuilder``` | NEMS application builder file used by NEMS/NEMSAppBuilder. |
| ```coupledFV3_MOM6_CICE_debug.appBuilder``` | NEMS application builder file used by NEMS/NEMSAppBuilder. |
| ```coupledFV3_MOM6_CICE_WW3.appBuilder```| NEMS application builder file used by NEMS/NEMSAppBuilder. |
| ```FMS```         | GFDL FMS with minor modifications from EMC. |
| ```FV3```         | FV3GFS code. |
| ```log```         | Log files from compiling and regression testing. |
| ```modulefiles``` | Files used for loading modules required for building and running ufs-s2s-model under NEMS on different computer systems. |
| ```MOM6```        | GFDL MOM6 source code with modifications from EMC. |
| ```NEMS```        | NEMS source code. |
| ```parm```        | A directory containing input namelist files and model configuration files. |
| ```stochastic_physics``` | A package containing the stochastic physics pattern generator developed at NOAA/ESRL/PSD. |
| ```WW3```         | WAVEWATCH III source code. |


# Disclaimer

The United States Department of Commerce (DOC) GitHub project code is provided on an "as is" basis and the user assumes responsibility for its use. DOC has relinquished control of the information and no longer has responsibility to protect the integrity, confidentiality, or availability of the information. Any claims against the Department of Commerce stemming from the use of its GitHub project will be governed by all applicable Federal law. Any reference to specific commercial products, processes, or services by service mark, trademark, manufacturer, or otherwise, does not constitute or imply their endorsement, recommendation or favoring by the Department of Commerce. The Department of Commerce seal and logo, or the seal and logo of a DOC bureau, shall not be used in any manner to imply endorsement of any commercial product or activity by DOC or the United States Government.
