.. _minio-k8s-production-considerations:

=========================
Production Considerations
=========================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

Overview
--------

This page documents considerations for deploying production-grade
MinIO Tenants on Kubernetes infrastructure.

Server Hardware
---------------

MinIO is hardware agnostic and runs on a variety of hardware architectures
ranging from ARM-based embedded systems to high-end x64 and POWER9 servers.

The following recommendations match MinIO's 
`Reference Hardware <https://min.io/product/reference-hardware>`__ for 
large-scale data storage:

.. list-table::
   :stub-columns: 1
   :widths: 20 80
   :width: 100%

   * - Processor
     - Dual Intel Xeon Scalable Gold CPUs with 8 cores per socket. 

   * - Memory
     - 128GB of Memory per pod

   * - Network
     - Minimum of 25GbE NIC and supporting network infrastructure between nodes.

       MinIO can make maximum use of drive throughput, which can fully saturate
       network links between MinIO nodes or clients. Large clusters may require
       100GbE network infrastructure to fully utilize MinIO's per-node 
       performance potential.

   * - Drives
     - SATA/SAS HDDs with a minimum of 8 drives per server. 


Networking
----------

MinIO recommends high speed networking to support the maximum possible
throughput of the attached storage (aggregated drives, storage controllers, 
and PCIe busses). The following table provides general guidelines for the 
maximum storage throughput supported by a given NIC:

.. list-table::
   :header-rows: 1
   :width: 100%
   :widths: 40 60

   * - NIC bandwidth (Gbps)
     - Estimated Aggregated Storage Throughput (GBps)

   * - 10GbE
     - 1GBps

   * - 25GbE
     - 2.5GBps
   
   * - 50GbE
     - 5GBps

   * - 100GbE
     - 10GBps

vCPU Allocation
---------------

MinIO benefits from allocating vCPU based on the expected per-host 
network throughput. The following table provides general guidelines for 
allocating vCPU for use by MinIO pods running on a worker node based on the 
total network bandwidth supported by that pod:

.. list-table::
   :header-rows: 1
   :width: 100%
   :widths: 40 60

   * - Host NIC Bandwidth
     - Recommended Pod vCPU

   * - 10GbE or less
     - 8 vCPU per pod.

   * - 25GbE
     - 16 vCPU per pod.

   * - 50GbE
     - 32 vCPU per pod.

   * - 100GbE
     - 64 vCPU per pod.

.. _minio-k8s-production-considerations-memory:

Memory Allocation
-----------------

MinIO benefits from allocating memory based on the total storage of each host.
The following table provides general guidelines for allocating memory for use 
by MinIO pods running on a worker node based on the total amount of storage 
supported by that pod.

.. list-table::
   :header-rows: 1
   :width: 100%
   :widths: 40 60

   * - Total Host Storage
     - Recommended Host Memory

   * - Up to 1 Tebibyte (Ti)
     - 8GiB

   * - Up to 10 Tebibyte (Ti)
     - 16GiB

   * - Up to 100 Tebibyte (Ti)
     - 32GiB
   
   * - Up to 1 Pebibyte (Pi)
     - 64GiB

   * - More than 1 Pebibyte (Pi)
     - 128GiB

