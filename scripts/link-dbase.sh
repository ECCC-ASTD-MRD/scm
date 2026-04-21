#!/bin/bash

# link to GEM and SCM databases at CMC
GEM_DBASE=/fs/ssm/eccc/mrd/rpn/MIG/GEM/d/gem-data/gem-data_4.2.0/gem-data_4.2.0_all/share/data/dfiles
SCM_DBASE=/fs/ssm/eccc/mrd/rpn/MIG/SCM/d/scm-data/scm-data_0.15.1_all

if [ ! -d ${GEM_DBASE} ] ; then
    echo "${GEM_DBASE} not found: don't know where database is."
    exit 1
fi

if [ ! -d ${SCM_DBASE} ] ; then
    echo "${SCM_DBASE} not found: don't know where database is."
    exit 1
fi

# remove possible existing link or file, and create symbolic link, 
# or display an error message (for example if a directory named gem_dbase already exists)
\rm -f gem_dbase && ln -s ${GEM_DBASE} gem_dbase || ( echo "gem_dbase cannot be removed" && exit 2)
\rm -f scm_dbase && ln -s ${SCM_DBASE} scm_dbase || ( echo "scm_dbase cannot be removed" && exit 2)


