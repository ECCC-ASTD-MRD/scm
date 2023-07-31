#!/bin/bash

# link to database at CMC

DOMAIN=`hostname -d`

if [[ "${DOMAIN}"  = cmc.ec.gc.ca ]]; then
    GEM_DBASE=/fs/ssm/eccc/mrd/rpn/MIG/GEM/d/gem-data/gem-data_4.2.0/gem-data_4.2.0_all/share/data/dfiles
    [ -e ${GEM_DBASE} ] && [ ! -e gem_dbase ] && ln -sf ${GEM_DBASE} gem_dbase
    SCM_DBASE=/fs/ssm/eccc/mrd/rpn/MIG/SCM/d/scm-data/scm-data_0.15.1_all
    [ -e ${SCM_DBASE} ] && [ ! -e scm_dbase ] && ln -sf ${SCM_DBASE} scm_dbase
elif [[ -z "${DOMAIN}" || ${DOMAIN} = "science.gc.ca" ]]; then
    GEM_DBASE=/fs/ssm/eccc/mrd/rpn/MIG/GEM/d/gem-data/gem-data_4.2.0/gem-data_4.2.0_all/share/data/dfiles
    [ -e ${GEM_DBASE} ] && [ ! -e gem_dbase ] && ln -sf ${GEM_DBASE} gem_dbase
    SCM_DBASE=/fs/ssm/eccc/mrd/rpn/MIG/SCM/d/scm-data/scm-data_0.15.1_all
    [ -e ${SCM_DBASE} ] && [ ! -e scm_dbase ] && ln -sf ${SCM_DBASE} scm_dbase
else
    echo "hostname not found: don't know where database is."
fi
