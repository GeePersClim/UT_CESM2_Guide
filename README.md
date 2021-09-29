# UT_CESM2_Guide
This repository contains three configuration files to port CESM2.1.3 to HPC Frontera at TACC at UT Austin.
They are config_batch.xml, config_compilers.xml, and config_machines.xml under config/ in this repository. 
Users should replace the three files with the ones from a standard CESM2.1.3 installation under /my_cesm_sandbox/cime/config/cesm/machines. 

In addition, the repository contains shell script example_run_cesm_frontera.sh to create, set up PE layout, build, and submit a case. 

Google doc links to several user guides are provided below. 

Last modified 04/21/2021. 

Table of Contents:
	1. Quick installation guide of CESM 2.1.3 on TACC HPC systems: 
  
  https://docs.google.com/document/d/1HetlGv0p64tZQtCTZvcOlEUj_ZJnQ5Z85I7c0jlz2c8/edit?usp=sharing
	
  2. Quick guide to create, setup, build and run a CESM case: 
  
  https://docs.google.com/document/d/13MmuPwESFoxPoUNs3jCXiy7aBpKamv8P8_z8t7upIAg/edit?usp=sharing
	
  3. * How to find the best PE layout (load balancing) for a model: 
  
  https://docs.google.com/document/d/1lSKuti8y7mn6HJBqIGd6mhlAwRg8r4-V6Y5s1TGTB6I/edit?usp=sharing
	
  4. A bash script example to run CESM2 cases on TACC HPC systems:
	
  https://docs.google.com/document/d/1y77hFSPUGzaKPhAhnD3c9myAGhLHYFarcW7mF9PdyFI/edit?usp=sharing
	
  5. A bash script example to resubmit a job on TACC HPC systems:
	
  https://docs.google.com/document/d/1R1Np6xRXD596c61D2reEaXrUUGbxYAYx9ToAmYwhTFQ/edit?usp=sharing
	
  6. Quick installation guide of CESM_postprocessing tool on TACC HPC systems:
	
  https://docs.google.com/document/d/1G9J0nvIh9lfvM_cM2vJPgWhKVWGkdSu1j26kw1GOpVA/edit?usp=sharing
	
  7. Quick guide to use CESM_postprocessing tool on Lonestar5:
  
	https://docs.google.com/document/d/110YEx_ZUQH6MLEhJyzya_tXg5W4Tf6PD7qCuZm5wnxs/edit?usp=sharing
