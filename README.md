# How to get, compile and run SCM at the CMC.
# SCM - Single Column Model

This project requires an X session to display results.
It is recommended to either run on EC machines or obtain a node on PPP with -X:

```
qsub -I -X -lselect=1:ncpus=80:mpiprocs=80:ompthreads=1:mem=100gb -lplace=scatter
```

Warning: this repository uses submodules. Make sure you follow the
instructions below.

## Getting scm git repository

### Choose one of the following methods:

1. cloning only the necessary components:
```
git clone git@gitlab.science.gc.ca:MIG/scm.git
cd scm
```

2. or cloning everything, including rpn-si libraries (rmn, vgrid, rpncomm, tdpack) in one step:
```
git clone --recursive git@gitlab.science.gc.ca:MIG/scm.git
cd scm
```

3. or cloning in several steps
```
git clone git@gitlab.science.gc.ca:MIG/scm.git
cd scm
```
Update rpn-si libraries and cmake_rpn submodules
```
git submodule update --init --recursive
```

## Choosing a version

```
git branch # what is the current branch
git branch -a # list all branches (look at the list of remote branches to choose from)
git tag # list tags (if you want to select a tagged version)
git checkout <hash|branch|tag> # checkout a branch, a tag, or a specific hash. Example: git checkout 5.3
File MANIFEST shows all the components and versions for hash|branch|tag checked out
```
Or, if you want, create your own branch from the current branch
```
git checkout -b mybranch
```

## Preparing scm compilation for Intel compiler
```
. ./.eccc_setup_intel
```

Before the first build, or if you made important changes (such as updating
other submodules, or adding or removing source files):
```
. ./.initial_setup
```
And before the first run, create these links to GEM and SCM databases
```
./scripts/link-dbase.sh
```

## Building and installing SCM

See cado -h (short help) or cado help.
For example: cado cmake generates Makefiles to compile scm, modelutils and rpnphy

Configure:
```
cado cmake
```

Compile:
```
cado build -j
```
Install in working directory
```
cado work -j
```
cado work -j can be used to compile and install in the same step.

In development mode, scm is compiled using Intel shared libraries: use the
following command to compile with static libraries:
```
cado cmake-static
```

See others options with cado -h (short help) or cado help

## Running SCM

```
cd $SCM_WORK
scmcase -get gabls-3
runscm
```

See examples in README-SCM file

## Structure of the working environment
The structure of the build and work directories is different whether the
$storage_model environment variable exists:

The following environment variables are created (examples):
- scm_DIR = directory where the git clone was created
- SCM_WORK = work directory
- SCM_ARCH = architecture, for example ubuntu-18.04-amd64-64-intel-2022.1.2
- COMPILER_SUITE = compiler suite, for example Intel
- COMPILER_VERSION = compiler version, for example 2022.1.2

- SCM_MODEL_DFILES = data base to run SCM cases
- ATM_MODEL_DFILES = data base for physics
- SCMDIAG_PLUGIN_PATH = plugin libraries for scmdiag
- SCMDIAG_SCRIPTS_LIBPATH = libraries for scmdiag

- SCM_STORAGE_DIR = where build and work directories are situated
  - Example if $storage_model variable exists:
    - SCM_STORAGE_DIR=/local/storage/scm/ubuntu-18.04-amd64-64-intel-2022.1.2
    - in scm_DIR:
      - build-ubuntu-18.04-amd64-64-intel-2022.1.2 is a link, such as:
        /local/storage/scm/ubuntu-18.04-amd64-64-intel-2022.1.2/build
      - work-ubuntu-18.04-amd64-64-intel-2022.1.2 is a link, such as:
        /local/storage/scm/ubuntu-18.04-amd64-64-intel-2022.1.2/work

  - Example if $storage_model variable doesn't exist:
    - SCM_STORAGE_DIR=$HOME/scm/
    - directories situated in scm_DIR:
      - build-ubuntu-18.04-amd64-64-intel-2022.1.2
      - work-ubuntu-18.04-amd64-64-intel-2022.1.2
