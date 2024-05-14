#FROM debian:latest AS build
FROM aiidateam/aiida-core-with-services AS build
#ENV ABINIT_VERSION=9.10.3
#ENV LAMMPS=stable_2Aug2023
ENV WORKER=8
LABEL org.opencontainers.image.authors="pthibaud@users.noreply.github.com"
RUN apt-get update && apt-get upgrade -y && apt-get dist-upgrade -y && apt-get autoclean && apt-get autoremove -y 
RUN apt-get install wget git gcc gfortran g++ libblas-dev liblapack-dev libfftw3-dev \
    cmake libxml2-dev libnetcdff-dev libxc-dev python3 python3-dev pip libzstd-dev \
    libopenmpi-dev sudo -y

# Quantum ESPRESSO
WORKDIR /home/dft
RUN git clone https://gitlab.com/QEF/q-e.git
WORKDIR /home/dft/q-e
RUN ./configure --prefix=/usr/local --enable-parallel=yes
RUN make -j ${WORKER} all && make install
WORKDIR /home/dft
RUN rm -fr q-e

# Wannier90
#TODO

# ABINIT
#WORKDIR /home/dft
#RUN wget -qO- https://www.abinit.org/sites/default/files/packages/abinit-${ABINIT_VERSION}.tar.gz | tar xz
#WORKDIR /home/dft/abinit-${ABINIT_VERSION}
#RUN ./configure --prefix=/usr/local --with-libxml2 -enable-openmp --with-mpi
#RUN make -j ${WORKER} && make install
#WORKDIR /home/dft
#RUN rm -fr abinit-${ABINIT_VERSION}

# LAMMPS 
#WORKDIR /home/md
#RUN wget -qO- https://github.com/lammps/lammps/archive/refs/tags/${LAMMPS}.tar.gz | tar xz 
#WORKDIR /home/md/lammps-${LAMMPS}/build
#RUN pip install setuptools
#RUN cmake -C../cmake/presets/most.cmake -DBUILD_SHARED_LIBS=on -DLAMMPS_EXCEPTIONS=on \
#    -DPKG_PYTHON=on -DCMAKE_INSTALL_PREFIX=/usr/local -DBUILD_OMP=yes \
#    -DCMAKE_CXX_COMPILER=g++-11 -DCMAKE_C_COMPILER=gcc-11 \
#    -DCMAKE_Fortran_COMPILER=gfortran-11 ../cmake
#RUN make -j ${WORKER} && make install
#WORKDIR /home/md
# this produce an error 
# RUN rm -fr ./lammps-${LAMMPS}

# update environment variable to get access to shared libraries
ENV LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:/usr/local/lib"

# Aiida stuffs with sudo privileges
RUN useradd -m aiida && echo "aiida:aiida" | chpasswd && adduser aiida sudo
RUN echo "aiida ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers && \
    chmod 0440 /etc/sudoers && \
    chmod g+w /etc/passwd

# Activating tab-completion
WORKDIR /home/aiida
RUN echo "eval \$(_VERDI_COMPLETE=bash_source verdi)" >> ~/.bashrc
RUN pip install --user aiida-quantumespresso
