
.. _kubectl-minio-tenant:

========================
``kubectl minio tenant``
========================

.. default-domain:: k8s

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: kubectl minio tenant

Description
-----------

.. start-kubectl-minio-tenant-desc

:mc-cmd:`kubectl minio tenant` creates a temporary proxy to forward traffic from the local host machine to the MinIO Operator Console. 
The :ref:`Operator Console <minio-operator-console>` provides a rich user interface for :ref:`deploying and managing MinIO Tenants <deploy-minio-tenant>`.

This command is an alternative to configuring `Ingress <https://kubernetes.io/docs/concepts/services-networking/ingress/>`__ to grant access to the Operator Console pods.

.. end-kubectl-minio-tenant-desc

.. include:: /includes/facts-kubectl-plugin.rst
   :start-after: start-kubectl-minio-requires-operator-desc
   :end-before: end-kubectl-minio-requires-operator-desc

Subcommands
-----------

The :mc-cmd:`kubectl minio tenant` command includes the following subcommands:

- :mc-cmd:`~kubectl minio tenant create`
- :mc-cmd:`~kubectl minio tenant list`
- :mc-cmd:`~kubectl minio tenant info`
- :mc-cmd:`~kubectl minio tenant expand`
- :mc-cmd:`~kubectl minio tenant report`
- :mc-cmd:`~kubectl minio tenant upgrade`
- :mc-cmd:`~kubectl minio tenant delete`

Syntax
------

.. tab-set::

   .. tab-item:: EXAMPLE

      The following command creates proxy to use to access the operator graphical user interface for the ``myminio`` namespace:

      .. code-block:: shell
         :class: copyable

         kubectl minio proxy --namespace myminio 
          
   .. tab-item:: SYNTAX

      The command has the following syntax:

      .. code-block:: shell
         :class: copyable

         kubectl minio init           \
                       [--namespace] 

Flags
-----

.. 
   Default values update frequently and can be found in the following files:
   https://github.com/minio/operator/blob/master/kubectl-minio/cmd/init.go
   https://github.com/minio/operator/blob/master/kubectl-minio/cmd/helpers/constants.go

   For minio/console, run ``kubectl minio init -o | grep minio/console``

The command supports the following flags:

.. mc-cmd:: --namespace
   :option:

   The namespace for which to access the operator.
   Defaults to ``minio-operator``.

.. toctree::
   :titlesonly:
   :hidden:

   /reference/kubectl-minio-plugin/kubectl-minio-tenant-create
   /reference/kubectl-minio-plugin/kubectl-minio-tenant-delete
   /reference/kubectl-minio-plugin/kubectl-minio-tenant-expand
   /reference/kubectl-minio-plugin/kubectl-minio-tenant-info
   /reference/kubectl-minio-plugin/kubectl-minio-tenant-list
   /reference/kubectl-minio-plugin/kubectl-minio-tenant-report
   /reference/kubectl-minio-plugin/kubectl-minio-tenant-upgrade