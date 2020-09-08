# MOM6-interface

MOM6-interface for NEMS coupled apps at EMC using MOM6.
This contains build, clean scripts and submodule pointers to MOM6.

# What files are what

The top level directory structure groups source code and input files as follow:

| File/directory       | Purpose |
| --------------       | ------- |
| ```clean.sh```       | A script to clean up build and exe files. |
| ```compile.sh```     | A compilation script to build MOM6 and cap using mkmf. |
| ```makefile.nuopc``` | Makefile for MOM6 NUOPC cap. |
| ```mkmf```           | Submodule to https://github.com/NOAA-EMC/mkmf |
| ```MOM6```           | Submodule to https://github.com/NOAA-EMC/MOM6 |

# Disclaimer

The United States Department of Commerce (DOC) GitHub project code is provided
on an 'as is' basis and the user assumes responsibility for its use. DOC has
relinquished control of the information and no longer has responsibility to
protect the integrity, confidentiality, or availability of the information. Any
claims against the Department of Commerce stemming from the use of its GitHub
project will be governed by all applicable Federal law. Any reference to
specific commercial products, processes, or services by service mark,
trademark, manufacturer, or otherwise, does not constitute or imply their
endorsement, recommendation or favoring by the Department of Commerce. The
Department of Commerce seal and logo, or the seal and logo of a DOC bureau,
shall not be used in any manner to imply endorsement of any commercial product
or activity by DOC or the United States Government.
