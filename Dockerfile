#FROM alpine:latest AS build
FROM debian:latest AS build
#ENV QE=qe-7.1
ENV ABINIT_VERSION=9.8.4
ENV LAMMPS=stable_23Jun2022_update4
ENV WORKER=4
LABEL org.opencontainers.image.authors="pthibaud@users.noreply.github.com"
RUN apt-get update
RUN apt-get install wget git gfortran g++-10 libblas-dev liblapack-dev libfftw3-dev \
    cmake libxml2-dev libnetcdff-dev libxc-dev python3 python3-dev pip libzstd-dev \
    libopenmpi-dev -y
# Quantum ESPRESSO
WORKDIR /home/dft
#RUN wget -qO- https://gitlab.com/QEF/q-e/-/archive/${QE}/q-e-${QE}.tar.gz | tar xz
#WORKDIR /home/dft/q-e-${QE}
RUN git clone https://gitlab.com/QEF/q-e.git
WORKDIR /home/dft/q-e
RUN ./configure --prefix=/usr/local --enable-parallel=yes
# RUN make -j ${WORKER} all && make install
#WORKDIR /home/dft
#RUN rm -fr q-e-${QE}
#RUN rm -fr q-e
# ABINIT
WORKDIR /home/dft
RUN wget -qO- https://www.abinit.org/sites/default/files/packages/abinit-${ABINIT_VERSION}.tar.gz | tar xz
WORKDIR /home/dft/abinit-${ABINIT_VERSION}
RUN ./configure --prefix=/usr/local --with-libxml2 -enable-openmp --with-mpi
# RUN make -j ${WORKER} && make install
#WORKDIR /home/dft
#RUN rm -fr abinit-${ABINIT_VERSION}
# LAMMPS 
WORKDIR /home/md
RUN wget -qO- https://github.com/lammps/lammps/archive/refs/tags/${LAMMPS}.tar.gz | tar xz 
WORKDIR /home/md/lammps-${LAMMPS}/build
RUN pip install setuptools
RUN cmake -C../cmake/presets/most.cmake -DBUILD_SHARED_LIBS=on -DLAMMPS_EXCEPTIONS=on \
    -DPKG_PYTHON=on -DCMAKE_INSTALL_PREFIX=/usr/local -DBUILD_OMP=yes \
    -DCMAKE_CXX_COMPILER=g++-10 ../cmake
# RUN make -j ${WORKER} && make install
#WORKDIR /home/md
# this produce an error 
#RUN rm -fr lammps-${LAMMPS}
