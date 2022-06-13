
.. _kubectl-minio-delete:

========================
``kubectl minio delete``
========================

.. default-domain:: k8s

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: kubectl minio delete

Description
-----------

.. include:: /includes/facts-kubectl-plugin.rst
   :start-after: start-kubectl-minio-requires-operator-desc
   :end-before: end-kubectl-minio-requires-operator-desc

.. start-kubectl-minio-delete-desc

Deletes the MinIO Operator along with all associated resources, including all MinIO Tenant instances in the :mc-cmd:`watched namespace <kubectl minio init namespace-to-watch>`.

.. end-kubectl-minio-delete-desc

.. warning::

   If the underlying Persistent Volumes (``PV``) were created with a reclaim policy of ``recycle`` or ``delete``, deleting the MinIO Tenant results in complete loss of all objects stored on the tenant.

   Ensure you have performed all due diligence in confirming the safety of any data on the MinIO Tenant prior to deletion.

Syntax
------

.. tab-set::

   .. tab-item:: SYNTAX

      The command has the following delete:

      .. code-block:: shell

         kubectl minio tenant delete       \
                              --namespace  
                                    
   .. tab-item:: EXAMPLE

      The following example expands a MinIO Tenant with a Pool consisting of 4 MinIO servers with 8 drives each and a total additional capacity of 32Ti:

      .. code-block:: shell

         kubectl minio tenant delete 

Flags
-----

The command supports the following flags:

.. mc-cmd:: --namespace
   :required:

   The namespace of the operator to delete.

   Defaults to ``minio-operator``. 

