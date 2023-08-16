SHELL = /bin/bash

# Makefile for Environment Canada systems
# Make sure you update the appropriate git submodules, according to what you want to build

default: build

MAKEFLAGS += --no-print-directory

# Using installed RPN libraries (rmn, vgrid, rpncomm, tdpack)
cmake:
	( cd build-${SCM_ARCH} && cd `/bin/pwd` && cmake ${scm_DIR} )

# Using installed RPN libraries (rmn, vgrid, rpncomm, tdpack) and static Intel libraries
cmake-static:
	( cd build-${SCM_ARCH} && cd `/bin/pwd` && cmake -DSTATIC_INTEL=ON ${scm_DIR} )

# Compiling everything: you need to update rpn-si libraries (rmn, vgrid, rpncomm, tdpack) submodules to do this
cmake-all:
	( export WITH_SYSTEM_RPN=FALSE && cd build-${SCM_ARCH} && cd `/bin/pwd` && cmake ${scm_DIR} )

# with CMAKE_BUILD_TYPE=Debug
cmake-debug:
	( cd build-${SCM_ARCH} && cd `/bin/pwd` && cmake -DCMAKE_BUILD_TYPE=Debug ${scm_DIR} )

# Extra debug (see extra checks defined in cmake_rpn compiler presets and in CMakeLists.txt)
cmake-debug-extra:
	( cd build-${SCM_ARCH} && cd `/bin/pwd` && cmake -DCMAKE_BUILD_TYPE=Debug -DEXTRA_CHECKS=ON ${scm_DIR} )

# Use installed RPN libraries and add MACH package
cmake-mach:
	( cd build-${SCM_ARCH} && cd `/bin/pwd` && cmake -DWITH_MACH=TRUE ${scm_DIR} )

# Using installed RPN libraries (rmn, vgrid, rpncomm, tdpack) and static Intel libraries
cmake-mach-static:
	( cd build-${SCM_ARCH} && cd `/bin/pwd` && cmake -DWITH_MACH=TRUE -DSTATIC_INTEL=ON ${scm_DIR} )

# Use installed RPN libraries and add MACH package with debug
cmake-mach-debug:
	( cd build-${SCM_ARCH} && cd `/bin/pwd` && cmake -DCMAKE_BUILD_TYPE=Debug -DWITH_MACH=TRUE ${scm_DIR} )

# Compiling everything with MACH package
cmake-all-mach:
	( export WITH_SYSTEM_RPN=FALSE && cd build-${SCM_ARCH} && cd `/bin/pwd` && cmake -DWITH_MACH=TRUE ${scm_DIR} )

.PHONY: build
build:
	( cd build-${SCM_ARCH} && cd `/bin/pwd` && $(MAKE) )

.PHONY: work
work: 
	( cd build-${SCM_ARCH} && cd `/bin/pwd` && $(MAKE) work )

package: 
	( cd build-${SCM_ARCH} && cd `/bin/pwd` && $(MAKE) package )

# make clean in build directory, to remove compiler and linker generated files
clean:
	( cd build-${SCM_ARCH} && cd `/bin/pwd` && $(MAKE) clean )

# Delete the build and work directories
distclean:
	. ./.clean_all


