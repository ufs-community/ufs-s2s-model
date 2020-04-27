# This file sets the location of configure.nems and modules.nems. 
# This file is included by the NEMS build system, within
# NEMS/GNUmakefile, just after platform logic is executed, but before
# the appbuilder file (if any) is read.

# IMPORTANT: This file MUST NOT CONTAIN any logic specific to building
# FV3, CCPP, FMS, MOM6, CICE, or NEMS.  Otherwise, applications will
# break.  There should only be logic specific this coupled app. 
#
# Logic specific to FV3, CCPP, FMS, or NEMS belong in NEMS/src/incmake.

# ----------------------------------------------------------------------
# Decide the conf and modulefile names.
# S2S_DEBUG_MODULE is defined in GNUmakefile
ifeq ($(S2S_DEBUG_MODULE),false)
  CHOSEN_MODULE=$(BUILD_TARGET)/fv3_coupled
else
  CHOSEN_MODULE=$(BUILD_TARGET)/fv3_coupled_debug
endif
$(info CHOSEN_MODULE is $(CHOSEN_MODULE))

CONFIGURE_NEMS_FILE=configure.fv3_coupled.$(BUILD_TARGET)

# ----------------------------------------------------------------------
# Exit for systems that are currently not supported
ifeq ($(BUILD_TARGET),gaea.intel)
  $(error App currently not supported on $(BUILD_TARGET))
else ifeq ($(BUILD_TARGET),jet.intel)
  $(error App currently not supported on $(BUILD_TARGET))
else ifeq ($(BUILD_TARGET),cheyenne.pgi)
  $(error App currently not supported on $(BUILD_TARGET))
endif
