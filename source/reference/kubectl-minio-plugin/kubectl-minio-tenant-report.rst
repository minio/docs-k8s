
.. _kubectl-minio-tenant-report:

===============================
``kubectl minio tenant report``
===============================

.. default-domain:: k8s

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: kubectl minio tenant report

Description
-----------

.. include:: /includes/facts-kubectl-plugin.rst
   :start-after: start-kubectl-minio-requires-operator-desc
   :end-before: end-kubectl-minio-requires-operator-desc

.. start-kubectl-minio-tenant-report-desc

Saves pod logs from the MinIO Tenant and its associated resources.

.. end-kubectl-minio-tenant-report-desc

The logs output to a zip archive file.

When unzipped, the contents include three files for each pool:

- JSON formatted file listing events
- JSON formatted file listing the status
- Human readable log file

The folder also contains the yaml file for the tenant in ``TENANT_NAME.yaml``

Syntax
------

.. tab-set::

   .. tab-item:: SYNTAX

      The command has the following syntax:

      .. code-block:: shell

         kubectl minio tenant report TENANT_NAME

                                    
   .. tab-item:: EXAMPLE

      The following example creates a MinIO Tenant in the namespace ``minio-tenant-1`` consisting of 4 MinIO servers with 8 drives each and a total capacity of 32Ti.

      .. code-block:: shell

         kubectl minio tenant report TENANT1
