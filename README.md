# bluespec

A small repo with the bare minimum to get started with bluespec
on the TU_Darmstadt Client SSH

## Init
Simply run the `init.sh` script once per session to validate your bluespec licence

## Simulating
To simulate a bluespec module run `make simulate`. This will, by default, look for a file called **Testbench.bsv** with
a module called **mkTestbench** and simulate that together with all it's dependencies.

Make sure the file and module names match, or overwrite them in the makefile. 
Output files will be placed in `/exec/`
