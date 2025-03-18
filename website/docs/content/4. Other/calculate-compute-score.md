# Compute Score

## Abstract

This document will explain in details how to prepare your systems for the benchmark, where to start the benchmark and how to review the scores.
The benchmark score is essential to be admitted in the SECA provider list and for each size, is a must to meet the minimum scores for each type of product you want to participate with, it is essential to participate with all the product's types

### Conditions

These are the baseline condition to run a test:

* The hardware where the test is running must be **the same** as your **production** hardware
* You can test one size of server at the time
* The VM running the Benchmark must be running the latest Linux Debian 12 cloud image
* At the time of the test the Hypervisor must be topped up wit the same type of VMs running the same OS as the Benchmark VM
  * For example: you are testing a SECA.L (8 CPU, 16 GB RAM), the VM being tested must be hosted on a Hypervisor which is hosting as many SECA.L type as possible,   all running Linux Debian 12.
* No additional software must be installed or run during the benchmark, not in he VM being tested not in the VMs running on the same Hypervisor

### Software

The software used for the benchmark is a collection of softwares made of:

* GeekBench6

### Minimum Score per SECA.Size

| Seca.Size | CPU/GB RAM | Min.SCORE |
| --------- | ---------- | --------- |
| SECA.2XS  | 1/1        | 750       |
| SECA.XS   | 1/2        | 1500      |
| SECA.S    | 2/4        | 3000      |
| SECA.M    | 4/8        | 6000      |
| SECA.L    | 8/16       | 12000     |
| SECA.XL   | 16/32      | 24000     |
| SECA.2XL  | 32/64      | 48000     |

### Automation

* Declare you want to be a SECA provider
* Subscribe ti services
* Upload ssh key for test purpose
* Prepare your environment
* Push specific file in github
* Wait for elaboration
