FROM alpine:latest AS build
RUN apk add --no-cache build-base git gfortran blas-dev lapack-dev fftw-dev bash
WORKDIR /home
RUN git clone https://gitlab.com/QEF/q-e.git
WORKDIR /home/q-e
RUN ./configure --enable-parallel=no
