Dockerfile for DFT and MD computer codes inside [AiiDA-code-with-services](https://www.aiida.net/) : 
- [Quantum ESPRESSO](https://www.quantum-espresso.org/)
- [ABINIT](https://www.abinit.org/)
- [LAMMPS](https://www.lammps.org/#gsc.tab=0)
- [Wannier90](https://wannier.org/)
- and several other analysis tools
on linux

```bash
podman build --format=docker --build-arg=proxy=<CEA_proxy> -t dockerDFT .
```
