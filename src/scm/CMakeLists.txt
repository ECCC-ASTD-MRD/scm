message(STATUS "(EC) Generating scmdyn libraries Makefile")

find_package(MPI)
if (MPI_FOUND)
   set(CMAKE_Fortran_COMPILER ${MPI_Fortran_COMPILER})
   set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} ${MPI_COMPILER_FLAGS}")
endif()

file(GLOB F_FILES */*.F90 utils/*F90)

set(CMAKE_Fortran_MODULE_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/modules )

add_library(scmdyn STATIC ${F_FILES})
target_link_libraries(scmdyn PRIVATE
   rpnphy
   rpnphy_cpl_stubs
   rpnphy_chm_stubs
   modelutils
   modelutils_tmg_stubs
   modelutils_ov_ifort
)

message(STATUS "(EC) Generating SCM binaries Makefile")

add_executable(mainscm main/mainscm.F90)
target_link_libraries(mainscm
   scmdyn
   rpnphy
   rpnphy_cpl_stubs
   rpnphy_chm_stubs
   modelutils
   modelutils_tmg_stubs
   modelutils_ov_ifort
   vgrid::vgrid
   tdpack::tdpack
   rpncomm::rpncomm
   rmn::rmn-ompi
   OpenMP::OpenMP_Fortran
   MPI::MPI_Fortran
   netcdff netcdf hdf5hl_fortran hdf5_hl hdf5_fortran hdf5 dl m z curl
   ${NETCDF_LIBRARIES}
   ${LAPACK_LIBRARIES}
   ${BLAS_LIBRARIES}
)

add_executable(fst2ptxt main/mainfst2ptxt.F90)
target_link_libraries(fst2ptxt
   scmdyn
   rpnphy
   rpnphy_chm_stubs
   rpnphy_cpl_stubs
   modelutils
   modelutils_tmg_stubs
   modelutils_ov_ifort
   vgrid::vgrid
   tdpack::tdpack
   rpncomm::rpncomm
   rmn::rmn-ompi
   OpenMP::OpenMP_Fortran
   MPI::MPI_Fortran
   ${LAPACK_LIBRARIES}
   ${BLAS_LIBRARIES}
)

add_executable(setfld main/mainsetfld.F90)
target_link_libraries(setfld
   scmdyn
   modelutils
   modelutils_tmg_stubs
   vgrid::vgrid
   tdpack::tdpack
   rpncomm::rpncomm
   rmn::rmn-ompi
   OpenMP::OpenMP_Fortran
   MPI::MPI_Fortran
   ${LAPACK_LIBRARIES}
   ${BLAS_LIBRARIES}
)

add_executable(forcedate main/mainforcedate.F90)
target_link_libraries(forcedate
   scmdyn
   modelutils
   modelutils_tmg_stubs
   vgrid::vgrid
   tdpack::tdpack
   rpncomm::rpncomm
   rmn::rmn-ompi
   OpenMP::OpenMP_Fortran
   MPI::MPI_Fortran
   ${LAPACK_LIBRARIES}
   ${BLAS_LIBRARIES}
)

install(TARGETS mainscm setfld forcedate fst2ptxt RUNTIME DESTINATION bin)
