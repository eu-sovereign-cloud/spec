# Compute Score

## Abstract

This document will explain in details how to prepare your systems for the benchmark, where to start the benchmark and how to review the scores.
The benchmark score is essential to be admitted in the SECA provider list and for each size, is a must to meet the minimum scores for each type of product you want to participate with, it is essential to participate with all the product's types

### Conditions

These are the baseline condition to run a test:

* The hardware where the test is running must be **the same** as your **production** hardware
* You can test one size of server at the time
* The VM running the Benchmark must be running the latest Debian Linux 12 cloud image
* At the time of the test the Hypervisor must be topped up wit the same type of VMs running the same OS as the Benchmark VM
  * For example: you are testing a SECA.L (8 CPU, 16 GB RAM), the VM being tested must be hosted on a Hypervisor which is hosting as many SECA.L type as possible, all running Debian Linux 12.
* No additional software must be installed or run during the benchmark, not in he VM being tested not in the VMs running on the same Hypervisor
* The use of swap memory is allowed during the benchmark process; however, it is recommended to only avoid it.
* Hyper-threads should not be considered as physical cores when evaluating or reporting the system's CPU configuration.

### Software

The benchmark utilizes a carefully selected suite of software tools to ensure accurate and reliable performance measurements. The primary software used is **GeekBench 6**, a cross-platform benchmarking tool that evaluates system performance across diverse workloads, including single-core and multi-core tasks.

This software ensures consistency and comparability of results across various hardware configurations, providing a standardized approach to performance assessment.

### Minimum Score per SECA.Size

The minimum single-core performance requirement is **500**. The table below outlines the required multi-core benchmark scores for each SECA instance size configuration.

| Seca.Size | vCPU/GB RAM | Min.SCORE |
| --------- | ----------- | --------- |
| SECA.2XS  | 1/1         | 500       |
| SECA.XS   | 1/2         | 750       |
| SECA.S    | 2/4         | 2200      |
| SECA.M    | 4/8         | 3500      |
| SECA.L    | 8/16        | 6000      |
| SECA.XL   | 16/32       | 9000      |
| SECA.2XL  | 32/64       | 13000     |
