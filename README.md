Dockerfile for DFT and MD computer codes inside [AiiDA-core-with-services](https://www.aiida.net/) : 
- [Quantum ESPRESSO](https://www.quantum-espresso.org/)
- [ABINIT](https://www.abinit.org/)
- [LAMMPS](https://www.lammps.org/)
- [Wannier90](https://wannier.org/)
- and several other analysis tools
on linux

```bash
podman build --format=docker --build-arg=proxy=<CEA_proxy> --build-arg=workers=<num_workers> -t dockerDFT .
```
