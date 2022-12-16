#FROM alpine:latest AS build
FROM debian:latest AS build
ENV QE=qe-7.1
ENV ABINIT_VERSION=9.6.2
ENV LAMMPS=stable_23Jun2022_update2
ENV WORKERS=1
LABEL org.opencontainers.image.authors="pthibaud@users.noreply.github.com"
#RUN apk add --no-cache build-base git gfortran blas-dev lapack-dev fftw-dev bash cmake libxml2-dev netcdf
RUN apt-get update
RUN apt-get install wget git gfortran g++-10 libblas-dev liblapack-dev libfftw3-dev cmake libxml2-dev libnetcdff-dev libxc-dev python3 python3-dev pip libzstd-dev -y
# Quantum ESPRESSO
WORKDIR /home/dft
RUN wget -qO- https://gitlab.com/QEF/q-e/-/archive/${QE}/q-e-${QE}.tar.gz | tar xz
WORKDIR /home/dft/q-e-${QE}
RUN ./configure --prefix=/usr/local --enable-parallel=no
RUN make -j ${WORKERS} all && make install
WORKDIR /home/dft
RUN rm -fr q-e-${QE}
# ABINIT
WORKDIR /home/dft
RUN wget -qO- https://www.abinit.org/sites/default/files/packages/abinit-${ABINIT_VERSION}.tar.gz | tar xz
WORKDIR /home/dft/abinit-${ABINIT_VERSION}
RUN ./configure --prefix=/usr/local --with-libxml2 -enable-openmp --without-mpi
RUN make -j ${WORKERS} && make install
WORKDIR /home/dft
RUN rm -fr abinit-${ABINIT_VERSION}
# LAMMPS 
WORKDIR /home/md
RUN wget -qO- https://github.com/lammps/lammps/archive/refs/tags/${LAMMPS}.tar.gz | tar xz 
WORKDIR /home/md/lammps-${LAMMPS}/build
RUN cmake -C../cmake/presets/most.cmake -DBUILD_SHARED_LIBS=on -DLAMMPS_EXCEPTIONS=on -DPKG_PYTHON=on -DCMAKE_INSTALL_PREFIX=/usr/local -DCMAKE_CXX_COMPILER=g++-10 ../cmake
RUN make -j ${WORKERS}
RUN pip install setuptools
RUN make install
WORKDIR /home/md
# this produce an error 
RUN rm -fr lammps-${LAMMPS}
