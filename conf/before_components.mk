# This file sets the location of configure.nems and modules.nems, and
# adds Make rules to create the tests/*.exe and tests/modules.* files.
# This file is included by the NEMS build system, within
# NEMS/GNUmakefile, just after platform logic is executed, but before
# the appbuilder file (if any) is read.

# IMPORTANT: This file MUST NOT CONTAIN any logic specific to building
# FV3, CCPP, FMS, MOM6, CICE, WW3 or NEMS.  Otherwise, applications will
# break.  There should only be logic specific this coupled app. 
#
# Logic specific to FV3, CCPP, FMS, WW3, or NEMS belong in NEMS/src/incmake.

# ----------------------------------------------------------------------
# Decide the conf and modulefile names.
# S2S_DEBUG_MODULE is defined in GNUmakefile

CHOSEN_MODULE=$(BUILD_TARGET)/fv3

ifeq ($(S2S_DEBUG_MODULE),true)
  CHOSEN_MODULE=$(BUILD_TARGET)/fv3_debug
endif

#$(info CHOSEN_MODULE is $(CHOSEN_MODULE))

CONFIGURE_NEMS_FILE=configure.fv3.$(BUILD_TARGET)

# ----------------------------------------------------------------------
# Copy the executable and modules.nems files into the tests/ directory
# if a TEST_BUILD_NAME is specified.
 
ifneq ($(TEST_BUILD_NAME),)
 $(info Will copy modules.nems and NEMS.x as $(TEST_BUILD_NAME) under tests/)
 $(ROOTDIR)/tests/$(TEST_BUILD_NAME).exe: $(NEMS_EXE)
	set -xe ; cp "$<" "$@"
 
 $(ROOTDIR)/tests/modules.$(TEST_BUILD_NAME): $(NEMSDIR)/src/conf/modules.nems
	set -xe ; cp "$<" "$@"
 
 configure: $(ROOTDIR)/tests/modules.$(TEST_BUILD_NAME) ;
 build: $(ROOTDIR)/tests/$(TEST_BUILD_NAME).exe ;
endif
