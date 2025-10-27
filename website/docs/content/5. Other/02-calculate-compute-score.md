# Compute Score

## Abstract

This document will explain in details:
- How to prepare your systems for the benchmark
- Where to run the benchmark
- What to measure against
  
The benchmarking is essential to measure the performances of the cloud server and to associate the right SECA size to the righe performance baseline in your infrastructure.
It is a must to meet the minimum numbers for scores and memory for each size the CSP wants to participate with.
In order to be part of SECA it is not essential or mandatory to participate with all the products and labels.

### Conditions

These are the baseline condition to run a test:

* The hardware tested must be **the same** as your **production** hardware
* You should test one size of server at the time
* No additional software must be installed or run during the benchmark, not in he VM being tested not in the VMs running on the same Hypervisor
* The use of swap memory is allowed during the benchmark process; however, it is recommended to avoid it.
* Hyper-threads should not be considered as physical cores when evaluating or reporting the system's CPU configuration.

### Software

The benchmark utilizes a carefully selected suite of software tools to ensure accurate and reliable performance measurements. 
The primary software used is **GeekBench 6**, a cross-platform benchmarking tool that evaluates system performance across diverse workloads, including single-core and multi-core tasks.

This software ensures consistency and comparability of results across various hardware configurations, providing a standardized approach to performance assessment.

### Shared or Dedicated vCPU

In SECA there are 2 types of classification for the compute scores

- Dedicated vCPU
- Shared vCPU

------

- Dedicated: In this model, each virtual CPU (vCPU) is assigned to a specific physical core, and only the virtual machine (VM) it’s assigned to can use it. This results in more consistent performance and less fluctuation over time, with reduced impact from other VMs. However, it tends to be more expensive.
- Shared: In this model, the CPUs and cores of the hypervisor are pooled together, and each VM gets a portion of the available resources. This can result in lower performance, particularly for workloads requiring multiple cores, and it is more susceptible to the noisy neighbor effect. However, it is more cost-effective.


### Minimum Score per SECA.Size Dedicated vCPU Flavour

The table below outlines the required multi-core benchmark scores for each SECA instance of Dedicated vCPU Type.
It is importanto to note that Size, RAM, baseline performance score are a requirement to flag a flavour with a specific Seca.Size.
The number of vCPU is instead a suggested value as you can get to the baseline performance score with any number of vCPU depending on type/architecture/frequency

| Seca.Size.Type |GB RAM | Min.SCORE | Suggested vCPU |
| --------- | ----------- | --------- | --------- |
| SECA.D2XS  | 1         | 500       |  1  |
| SECA.DXS  | 2         | 750       |  1  |
| SECA.DS    | 4         | 2200      |  2  |
| SECA.DM.    | 8         | 3500      |  4  |
| SECA.DL    | 16        | 6000      |  8  |
| SECA.DXL   | 32       | 9000      |  16  |
| SECA.D2XL  | 64       | 13000     |  32  |

> SECA Standard SKUs will be provided under **seca** tenant (e.g: skuRef: /tenants/seca/d2xs)

### Minimum Score per SECA.Size Shared vCPU Flavour

The table below outlines the required multi-core benchmark scores for each SECA instance of Shared Type.
It is importanto to note that Size, RAM, baseline performance score are a requirement to flag a flavour with a specific Seca.Size.
The number of vCPU is instead a suggested value as you can get to the baseline performance score with any number of vCPU depending on type/architecture/frequency

| Seca.Size.Type | GB RAM | Min.SCORE | Suggested vCPU |
| --------- | ----------- | --------- | --------- |
| SECA.S2XS  | 1         | 500       | 1 |
| SECA.SXS   | 2         | 700       | 1 |
| SECA.SS    | 4         | 2000      | 2 |
| SECA.SM    | 8         | 3000      | 4 |
| SECA.SL    | 16        | 5500      | 8 |
| SECA.SXL   | 32       | 8000      | 16 |
| SECA.S2XL  | 64       | 9000     | 32 |

> SECA Standard SKUs will be provided under **seca** tenant (e.g: skuRef: /tenants/seca/s2xs)
