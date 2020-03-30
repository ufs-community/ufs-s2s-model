#!/usr/bin/env python

import os
import sys

#STEP = 'INPUT'
#STEP = 'COLD'
STEP = 'WARM'
#STEP = None

BLDIR = '/scratch1/BMC/gmtb/Dom.Heinzeller/FV3_RT/FV3-MOM6-CICE5_BASELINES/develop-20200326-test'
RTDIR = '/scratch1/BMC/gmtb/Dom.Heinzeller/FV3_RT/rtgen.18567/tmp'

INPUT_DIR = '/scratch1/BMC/gmtb/Dom.Heinzeller/FV3_RT/FV3-MOM6-CICE5_BASELINES/develop-20200326'
INPUT_DATA = [
    'BM_IC',
    'CICE_FIX',
    'CICE_IC',
    'FV3_input_bm2',
    'CPL_FIX',
    'FV3_input_data',
    'FV3_input_data384',
    'MOM6_FIX',
    'MOM6_IC',
    'REGTEST-FINGERPRINT.md',
    'WW3_input_data',
    ]

TESTDIRS_COLD = {
    'cpld_fv3_mom6_cice_cold_atm_flux'               : { "CNTL_NAME" : "RT-Baselines_cold"                , "CNTLMED" : "MEDIATOR"                },
    'cpld_fv3_384_mom6_cice_cold_atm_flux'           : { "CNTL_NAME" : "RT-Baselines_cold384"             , "CNTLMED" : "MEDIATOR384"             },
    'cpld_fv3_mom6_cice_cold_satmedmf'               : { "CNTL_NAME" : "RT-Baselines_cold_satmedmf"       , "CNTLMED" : "MEDIATOR_satmedmf"       },
    'cpld_fv3_384_mom6_cice_cold_bmark_rt'           : { "CNTL_NAME" : "RT-Baselines_cold_bmrt"           , "CNTLMED" : "MEDIATOR_bmrt"           },
    'cpld_fv3_384_mom6_cice_ww3_cold_bmark_rt'       : { "CNTL_NAME" : "RT-Baselines_cold_bmwav"          , "CNTLMED" : "MEDIATOR_bmwav"          },
    'cpld_fv3_mom6_cice_cold_atm_flux_repro'         : { "CNTL_NAME" : "RT-Baselines_cold_repro"          , "CNTLMED" : "MEDIATOR_repro"          },
    'cpld_fv3_384_mom6_cice_cold_atm_flux_repro'     : { "CNTL_NAME" : "RT-Baselines_cold384_repro"       , "CNTLMED" : "MEDIATOR384_repro"       },
    'cpld_fv3_mom6_cice_cold_satmedmf_repro'         : { "CNTL_NAME" : "RT-Baselines_cold_satmedmf_repro" , "CNTLMED" : "MEDIATOR_satmedmf_repro" },
    'cpld_fv3_384_mom6_cice_cold_bmark_rt_repro'     : { "CNTL_NAME" : "RT-Baselines_cold_bmrt_repro"     , "CNTLMED" : "MEDIATOR_bmrt_repro"     },
    'cpld_fv3_384_mom6_cice_ww3_cold_bmark_rt_repro' : { "CNTL_NAME" : "RT-Baselines_cold_bmwav_repro"    , "CNTLMED" : "MEDIATOR_bmwav_repro"    },
    'cpld_fv3_ccpp_mom6_cice_cold_atm_flux'          : { "CNTL_NAME" : "RT-Baselines_cold_ccpp"           , "CNTLMED" : "MEDIATOR_ccpp"           },
    'cpld_fv3_ccpp_384_mom6_cice_cold_atm_flux'      : { "CNTL_NAME" : "RT-Baselines_cold384_ccpp"        , "CNTLMED" : "MEDIATOR384_ccpp"        },
    'cpld_fv3_ccpp_mom6_cice_cold_satmedmf'          : { "CNTL_NAME" : "RT-Baselines_cold_satmedmf_ccpp"  , "CNTLMED" : "MEDIATOR_satmedmf_ccpp"  },
    'cpld_fv3_ccpp_384_mom6_cice_cold_bmark_rt'      : { "CNTL_NAME" : "RT-Baselines_cold_bmrt_ccpp"      , "CNTLMED" : "MEDIATOR_bmrt_ccpp"      },
    'cpld_fv3_ccpp_384_mom6_cice_ww3_cold_bmark_rt'  : { "CNTL_NAME" : "RT-Baselines_cold_bmwav_ccpp"     , "CNTLMED" : "MEDIATOR_bmwav_ccpp"     },
    }

TESTDIRS_WARM = {
    'cpld_fv3_mom6_cice_2d_atm_flux'                 : { "CNTL_NAME" : "RT-Baselines_2d_warm"                , "WW3" : False },
    'cpld_fv3_384_mom6_cice_2d_atm_flux'             : { "CNTL_NAME" : "RT-Baselines_2d_warm384"             , "WW3" : False },
    'cpld_fv3_mom6_cice_1d_satmedmf'                 : { "CNTL_NAME" : "RT-Baselines_1d_warm_satmedmf"       , "WW3" : False },
    'cpld_fv3_384_mom6_cice_1d_bmark_rt'             : { "CNTL_NAME" : "RT-Baselines_1d_bmrt"                , "WW3" : False },
    'cpld_fv3_384_mom6_cice_ww3_1d_bmark_rt'         : { "CNTL_NAME" : "RT-Baselines_1d_bmwav"               , "WW3" : True  },
    'cpld_fv3_mom6_cice_2d_atm_flux_repro'           : { "CNTL_NAME" : "RT-Baselines_2d_warm_repro"          , "WW3" : False },
    'cpld_fv3_384_mom6_cice_2d_atm_flux_repro'       : { "CNTL_NAME" : "RT-Baselines_2d_warm_repro384"       , "WW3" : False },
    'cpld_fv3_mom6_cice_1d_satmedmf_repro'           : { "CNTL_NAME" : "RT-Baselines_1d_warm_satmedmf_repro" , "WW3" : False },
    'cpld_fv3_384_mom6_cice_1d_bmark_rt_repro'       : { "CNTL_NAME" : "RT-Baselines_1d_bmrt_repro"          , "WW3" : False },
    'cpld_fv3_384_mom6_cice_ww3_1d_bmark_rt_repro'   : { "CNTL_NAME" : "RT-Baselines_1d_bmwav_repro"         , "WW3" : True  },
    'cpld_fv3_ccpp_mom6_cice_2d_atm_flux'            : { "CNTL_NAME" : "RT-Baselines_2d_warm_ccpp"           , "WW3" : False },
    'cpld_fv3_ccpp_384_mom6_cice_2d_atm_flux'        : { "CNTL_NAME" : "RT-Baselines_2d_warm_ccpp384"        , "WW3" : False },
    'cpld_fv3_ccpp_mom6_cice_1d_satmedmf'            : { "CNTL_NAME" : "RT-Baselines_1d_warm_satmedmf_ccpp"  , "WW3" : False },
    'cpld_fv3_ccpp_384_mom6_cice_1d_bmark_rt'        : { "CNTL_NAME" : "RT-Baselines_1d_bmrt_ccpp"           , "WW3" : False },
    'cpld_fv3_ccpp_384_mom6_cice_ww3_1d_bmark_rt'    : { "CNTL_NAME" : "RT-Baselines_1d_bmwav_ccpp"          , "WW3" : True  },
    #'cpld_fv3_mom6_cice_2d_2threads'                 : { "CNTL_NAME" : "RT-Baselines_2d_warm"                , "WW3" : False },
    #'cpld_fv3_mom6_cice_2d_decomp'                   : { "CNTL_NAME" : "RT-Baselines_2d_warm"                , "WW3" : False },
    #'cpld_fv3_mom6_cice_2d_2threads_repro'           : { "CNTL_NAME" : "RT-Baselines_2d_warm_repro"          , "WW3" : False },
    #'cpld_fv3_mom6_cice_2d_decomp_repro'             : { "CNTL_NAME" : "RT-Baselines_2d_warm_repro"          , "WW3" : False },
    #'cpld_fv3_ccpp_mom6_cice_2d_2threads'            : { "CNTL_NAME" : "RT-Baselines_2d_warm_ccpp"           , "WW3" : False },
    #'cpld_fv3_ccpp_mom6_cice_2d_decomp'              : { "CNTL_NAME" : "RT-Baselines_2d_warm_ccpp"           , "WW3" : False },
    }

def rsync(src, dst, include_exclude=''):
    if not src.endswith('/'):
        src += '/'
    if not dst.endswith('/'):
        dst += '/'
    # Do not use --delete !!!
    cmd = 'rsync {} -av {} {}'.format(include_exclude, src, dst)
    #cmd = 'rsync --dry-run {} -av {} {}'.format(include_exclude, src, dst)
    status = os.system(cmd)
    print "Executing '{}'".format(cmd)
    if not status == 0:
        raise Exception("Command '{}' finished with exit code {}".format(cmd, status))

def copy(src, dst):
    cmd = 'cp -av {} {}'.format(src, dst)
    status = os.system(cmd)
    print "Executing '{}'".format(cmd)
    if not status == 0:
        raise Exception("Command '{}' finished with exit code {}".format(cmd, status))

#################



if STEP == 'INPUT':
    if not os.path.isdir(INPUT_DIR):
        raise Exception("INPUT_DIR {} does not exist".format(INPUT_DIR))
    elif os.path.isdir(BLDIR):
        raise Exception("BLDIR {} already exists".format(BLDIR))
    for data in INPUT_DATA:
        src = os.path.join(INPUT_DIR, data)
        dst = os.path.join(BLDIR, data)
        if os.path.isdir(src):
            rsync(src, dst)
        else:
            copy(src, dst)

elif STEP == 'COLD':
    if not os.path.isdir(RTDIR):
        raise Exception("RTDIR {} does not exist".format(RTDIR))
    elif not os.path.isdir(BLDIR):
        raise Exception("BLDIR {} does not exist".format(BLDIR))
    for testdir in TESTDIRS_COLD.keys():
        # Output and restart files FV3
        src = os.path.join(RTDIR, testdir)
        dst = os.path.join(BLDIR, TESTDIRS_COLD[testdir]['CNTL_NAME'])
        rsync(src, dst, include_exclude='--include="dynf*.tile*.nc" --include="phyf*.tile*.nc" --include="RESTART/*" --include="RESTART" --exclude="*"')
        # Mediator files
        src = os.path.join(RTDIR, testdir)
        dst = os.path.join(BLDIR, TESTDIRS_COLD[testdir]['CNTLMED'])
        rsync(src, dst, include_exclude='--include="mediator*.nc" --include="mediator_scalars_restart.txt" --exclude="*"')
        # Restart files MOM6 and CICE5
        src = os.path.join(RTDIR, testdir, 'MOM6_RESTART')
        dst = os.path.join(BLDIR, TESTDIRS_COLD[testdir]['CNTL_NAME'], 'RESTART')
        rsync(src, dst, include_exclude='--include="*.nc" --exclude="*"')
        # Restart files CICE5
        src = os.path.join(RTDIR, testdir, 'restart')
        dst = os.path.join(BLDIR, TESTDIRS_COLD[testdir]['CNTL_NAME'], 'RESTART')
        rsync(src, dst, include_exclude='--include="*.nc" --exclude="*"')

elif STEP == 'WARM':
    if not os.path.isdir(RTDIR):
        raise Exception("RTDIR {} does not exist".format(RTDIR))
    elif not os.path.isdir(BLDIR):
        raise Exception("BLDIR {} does not exist".format(BLDIR))
    for testdir in TESTDIRS_WARM.keys():
        # Output and restart files
        src = os.path.join(RTDIR, testdir)
        dst = os.path.join(BLDIR, TESTDIRS_WARM[testdir]['CNTL_NAME'])
        rsync(src, dst, include_exclude='--include="dynf048.tile*.nc" --include="phyf048.tile*.nc" --include="dynf024.tile*.nc" --include="phyf024.tile*.nc" --include="RESTART/*" --include="RESTART" --exclude="*"')
        # Special output files for WW3
        if TESTDIRS_WARM[testdir]['WW3']:
            rsync(src, dst, include_exclude='--include="*.out_pnt.points" --include="*.out_grd.glo_30m" --exclude="*"')
            src = os.path.join(RTDIR, testdir)
            dst = os.path.join(BLDIR, TESTDIRS_WARM[testdir]['CNTL_NAME'], "RESTART")
            rsync(src, dst, include_exclude='--include="*.restart.glo_30m" --exclude="*"')
        # Mediator files go to RESTART directory
        src = os.path.join(RTDIR, testdir)
        dst = os.path.join(BLDIR, TESTDIRS_WARM[testdir]['CNTL_NAME'], "RESTART")
        rsync(src, dst, include_exclude='--include="mediator*.nc" --include="mediator_scalars_restart.txt" --exclude="*"')
        # Restart files MOM6 and CICE5
        src = os.path.join(RTDIR, testdir, 'MOM6_RESTART')
        dst = os.path.join(BLDIR, TESTDIRS_WARM[testdir]['CNTL_NAME'], 'RESTART')
        rsync(src, dst, include_exclude='--include="*.nc" --exclude="*"')
        # Restart files CICE5
        src = os.path.join(RTDIR, testdir, 'restart')
        dst = os.path.join(BLDIR, TESTDIRS_WARM[testdir]['CNTL_NAME'], 'RESTART')
        rsync(src, dst, include_exclude='--include="*.nc" --exclude="*"')
