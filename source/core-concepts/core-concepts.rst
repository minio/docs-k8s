=============
Core Concepts
=============

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

Erasure Coding
--------------

MinIO Erasure Coding is a data redundancy and availability feature that allows
MinIO deployments to automatically reconstruct objects on-the-fly despite the
loss of multiple drives or nodes in the cluster. Erasure Coding provides
object-level healing with less overhead than adjacent technologies such as
RAID or replication. 

Erasure Coding splits objects into data and parity blocks, where parity blocks
support reconstruction of missing or corrupted data blocks. MinIO distributes
both data and parity blocks across ::mc:`minio server <minio.server>` nodes and
drives in an :ref:`Erasure Set <minio-ec-erasure-set>`. Depending on the
configured parity, number of nodes, and number of drives per node in the Erasure
Set, MinIO can tolerate the loss of up to half (``N/2``) of drives and still
retrieve stored objects.

The following table lists the outcome of varying EC levels on a MinIO 
Tenant with a single 16-drive server pool:

.. list-table:: Outcome of Parity Settings on a 16-Drive Server Pool
   :header-rows: 1
   :widths: 20 20 20 20 20
   :width: 100%

   * - Parity
     - Total Storage
     - Storage Ratio
     - Minimum Drives for Read Operations
     - Minimum Drives for Write Operations

   * - ``EC: 4``
     - 12 Tebibytes
     - 0.750
     - 12
     - 13

   * - ``EC: 6``
     - 10 Tebibytes
     - 0.625
     - 10
     - 11

   * - ``EC: 8``
     - 8 Tebibytes
     - 0.500
     - 8
     - 9

Since parity blocks require storage space, higher levels of parity 
provide increased tolerance to drive or pod failure at the cost of
total usable storage capacity.

MinIO supports two parity levels: Standard (default) and Reduced. The default
parity levels for a Tenant depends on the MinIO version deployed on that Tenant:

- For MinIO version :release:`RELEASE.2021-01-30T00-20-58Z` and later, 
  the default standard ``EC`` depends on the number of volumes in the erasure
  set:

  - For 8 or more volumes, ``EC:4``
  - For 6-7 volumes, ``EC:3``
  - For 4-5 volumes, ``EC:2``

- For MinIO version :release:`RELEASE.2021-01-16T02-19-44Z` or earlier, 
  the default ``EC`` is 1/2 the drives in the erasure set. For example,
  a 16-drive server pool has ``EC:8``.

You can set a custom erasure code parity setting by specifying the 
:envvar:`MINIO_STORAGE_CLASS_STANDARD` and 
:envvar:`MINIO_STORAGE_CLASS_RRS` environment variables for 
standard and reduced parity respectively. Use the 
:minio-crd:`env <TenantSpec>` to specify the environment variables as part of 
the MinIO Tenant ``YAML`` specification *prior* to creating the Tenant. 

For more complete documentation on erasure coding, see 
:ref:`minio-erasure-coding`.

Bucket Versioning
-----------------

MinIO supports keeping multiple “versions” of an object in a single bucket.
Write operations which would normally overwrite an existing object instead
result in the creation of a new versioned object. MinIO versioning protects from
unintended overwrites and deletions while providing support for “undoing” a
write operation. Bucket versioning also supports retention and archive policies.

MinIO generates a unique immutable ID for each object. If a PUT request contains
an object name which duplicates an existing object, MinIO does not overwrite the
“older” object. Instead, MinIO retains all object versions while considering the
most recently written “version” of the object as “latest”. Applications retrieve
the latest object version by default, but may retrieve any other version in the
history of that object.

You can enable or disable bucket versioning at any time using the 
:mc-cmd:`mc version enable <mc.version.enable>` command. See 
:ref:`minio-bucket-versioning` for more complete documentation. 
