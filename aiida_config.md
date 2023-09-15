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
podman volume create aiida-home
```

3. Run a container
```bash
podman run -d --name aiida -v aiida-home:/home/aiida:Z localhost/aiida-dft:latest 
```

4. Execute a shell inside
```bash
podman exec -it --user aiida aiida /bin/bash 
```

5. Check setup inside the container
```bash
% verdi status
```

6. Inside the container, upgrade and install aiida-quantumespresso
```bash
% pip install aiida-quantumespresso
```
7. Reset the daemon
```bash
% verdi daemon restart --reset
``` 
8. (optional) verify the list of aiida plugins
```bash
% verdi plugin list
```

