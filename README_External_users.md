# SCM – User README (for external users)

## Quick Start

```bash
# Clone repository with submodules
git clone --branch scm_2.3-branch --recursive https://github.com/ECCC-ASTD-MRD/scm.git
cd scm

# If --recursive was not used:
git submodule update --init --recursive

# Download required databases
./utils/download-GEM-dbase.sh .
./utils/download-SCM-dbase.sh .

# Load environment (after setting up your compiler)
. ./.common_setup gnu
# or
. ./.common_setup intel

# Build (Method 1)
mkdir -p build && cd build
cmake ..
make -j work

# Go to working directory
cd work-[OS_NAME]-[COMPILER_NAME]
# or
cd $SCM_WORK
```

👉 See `README-SCM` in the work directory for usage examples.

---

## Extended Instructions

## Requirements

You will need:
- Fortran and C compilers
- MPI implementation (e.g., OpenMPI + development package)
- OpenMP support
- BLAS/LAPACK or equivalent (e.g., MKL)
- R
- Unix tools: `cmake` (≥ 3.20), `bash`, `sed`, etc.

---

## Data Setup

Run:

```bash
./utils/download-GEM-dbase.sh .
./utils/download-SCM-dbase.sh .
```

Alternatively, download and extract the datasets manually using the links provided in these scripts.

---

## Build Options

### ✅ Method 1 (Standard CMake)

```bash
mkdir build
cd build
cmake ..
make -j work
```

### ✅ Method 2 (Automated setup via `cado`)

```bash
. ./.initial_setup
cado cmake
cado work -j
```

✔ Automatically creates build + work directories
✔ No need to manually cd build

---

## Running SCM

After build, a directory is created:
```
work-[OS_NAME]-[COMPILER_NAME]
```
Example:
```
work-FedoraLinux-43-x86_64-gnu-15.2.1
```

Use:

```bash
cd $SCM_WORK
```

👉 See `README-SCM` in the work directory for usage examples.

---

##  Environment Variables

| Variable | Description |
|----------|-------------|
| scm_DIR | SCM root directory |
| SCM_WORK | Working directory |
| SCM_ARCH | Architecture identifier |
| ATM_MODEL_DFILES | Database path |
| COMPILER_SUITE | Compiler |
| COMPILER_VERSION | Version |

---

## Compiler Configuration

### GNU (default)

- Uses gcc / gfortran + OpenMPI
- Configuration files:
  - CMakeLists.txt (under the section **# Adding specific flags for SCM**)
  - cmake_rpn/modules/ec_compiler_presets/default/Linux-x86_64/gnu.cmake
    (check C and Fortran flags)
- Check the PATH and LD_LIBRARY_PATH (maybe needed for NetCDF location)

Example environment setup:

```bash
export PATH=/usr/lib/openmpi/bin:$PATH
export LD_LIBRARY_PATH=/usr/lib/openmpi/lib:$LD_LIBRARY_PATH
```

### Intel

```bash
cmake .. -DCOMPILER_SUITE=intel
```
Notes:

- May need to adjust ```-march```
- Configuration files:
  - CMakeLists.txt (under the section **# Adding specific flags for SCM**)
  - cmake_rpn/modules/ec_compiler_presets/default/Linux-x86_64/intel.cmake
    (check C and Fortran flags)
- Check the PATH and LD_LIBRARY_PATH (maybe needed for NetCDF location)

### Other compilers

This release has been tested with GNU and Intel compilers on Linux x86_64.
Other compilers have also been used in the past, but have not been tested
with the current release.  You will likely have to modify the *.cmake files
in the **cmake_rpn/modules/ec_compiler_presets/default/** folder.

---

## Advanced Build Options

| Option | Description |
|----------|-------------|
| -DCMAKE_VERBOSE_MAKEFILE=ON | Show full compile commands |
| -DWITH_OPENMP=OFF | Disable OpenMP |
| -j | Parallel build |

---

## Troubleshooting

### Common issues

**MPI / compiler not found** → Check:

```bash
echo $PATH
echo $LD_LIBRARY_PATH
```

**Wrong compiler settings**

```bash
rm -rf build/*
cmake ..
```

**Database not found**

- Make sure you downloaded them in the root directory
- Use the following in the root directory:
```bash
. ./.common_setup gnu
# or 
. ./.common_setup intel
```

---

##  Documentation

- README-SCM → examples and usage
- share/doc/SCM_userguide.pdf → full user guide

---

## Summary

1. Clone + submodules
2. Download databases
3. Load environment
4. Build
5. Run from `$SCM_WORK`
