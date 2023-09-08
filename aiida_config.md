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

2. Prepare a permanent data storage between host and container
```bash
podman volume create aiida-home-data
```

3. Run a container
```bash
podman run -d --name aiida -v aiida-home-data:/home/aiida:Z localhost/aiida-dft:latest 
```

4. Execute a shell inside
```bash
podman exec -it --user aiida aiida /bin/bash 
```