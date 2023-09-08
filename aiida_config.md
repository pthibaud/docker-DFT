# Aiida configuration files

0. In order to build the DFT and MD codes, uncomment these lines in Dockerfile
```bash
# RUN make -j ${WORKER} all && make install
# RUN make -j ${WORKER} && make install
# RUN make -j ${WORKER} && make install
```
1. Prepare the image

```bash
podman build -t aiida-dft .
```
This may take several minutes depending your computer.