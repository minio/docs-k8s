:orphan:

.. _minio-kubectl-plugin:

=======================
MinIO Kubernetes Plugin
=======================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

Overview
--------

.. admonition:: Current Stable Version is |operator-version-stable|
   :class: note

   This reference documentation reflects |operator-version-stable| of the 
   MinIO Kubernetes Operator and :mc:`kubectl minio` plugin. 

The :mc:`kubectl minio` plugin brings native support for deploying MinIO tenants
to Kubernetes clusters using the ``kubectl`` CLI. You can use 
:mc:`kubectl minio` to deploy a MinIO tenant with little to no interaction with 
``YAML`` configuration files.

.. image:: /images/Kubernetes-Minio.svg
   :align: center
   :width: 90%
   :class: no-scaled-link
   :alt: Kubernetes Orchestration with the MinIO Operator facilitates automated deployment of MinIO clusters.

Installing :mc:`kubectl minio` implies installing the
:minio-git:`MinIO Kubernetes Operator <operator>`.

.. _minio-plugin-installation:

.. mc:: kubectl minio

Installation
------------

The MinIO Kubernetes Plugin requires Kubernetes 1.19.0 or later:

The following code downloads the latest stable version |operator-version-stable|
of the MinIO Kubernetes Plugin and installs it to the system ``$PATH``:


.. code-block:: shell
   :substitutions:
   :class: copyable

   wget https://github.com/minio/operator/releases/download/v|operator-version-stable|/kubectl-minio_|operator-version-stable|_linux_amd64 -O kubectl-minio
   chmod +x kubectl-minio
   mv kubectl-minio /usr/local/bin/

You can access the plugin using the :mc:`kubectl minio` command. Run 
the following command to verify installation of the plugin:

.. code-block:: shell
   :class: copyable

   kubectl minio version


Delete the MinIO Operator
~~~~~~~~~~~~~~~~~~~~~~~~~

.. mc-cmd:: delete
   :fullpath:

   Deletes the MinIO Operator along with all associated resources, 
   including all MinIO Tenant instances in the
   :mc-cmd:`watched namespace <kubectl minio init namespace-to-watch>`.

   .. warning::

      If the underlying Persistent Volumes (``PV``) were created with
      a reclaim policy of ``recycle`` or ``delete``, deleting the MinIO
      Tenant results in complete loss of all objects stored on the tenant.

      Ensure you have performed all due diligence in confirming the safety of
      any data on the MinIO Tenant prior to deletion.

   The command has the following syntax:

   .. code-block:: shell
      :class: copyable

      kubectl minio delete [FLAGS]

   The command accepts the following arguments:

   .. mc-cmd:: namespace
      :option:

      The namespace of the MinIO operator to delete.

      Defaults to ``minio-operator``.




Upgrade MinIO Tenant
~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/facts-kubectl-plugin.rst
   :start-after: start-kubectl-minio-requires-operator-desc
   :end-before: end-kubectl-minio-requires-operator-desc

.. mc-cmd:: tenant upgrade
   :fullpath:

   Upgrades the ``minio`` server Docker image used by the MinIO Tenant.
   
   .. important::

      MinIO upgrades the image used by all pods in the Tenant at once. This may
      result in downtime until the upgrade process completes.

   .. tab-set::

      .. tab-item:: SYNTAX

         The command has the following syntax:

         .. code-block:: shell

            kubectl minio tenant upgrade TENANT_NAME FLAGS [FLAGS]

      .. tab-item:: EXAMPLE

         The following example upgrades a MinIO Tenant to use the latest 
         stable version of the MinIO server:

         .. code-block:: shell

            kubectl minio tenant upgrade minio-tenant-1 \
              --image  minio/minio

   The command supports the following arguments:

   .. mc-cmd:: TENANT_NAME

      *Required*

      The name of the MinIO Tenant which the command updates.

   .. mc-cmd:: image
      :option:

      *Required*

      The Docker image to use for upgrading the MinIO Tenant.

   .. mc-cmd:: namespace
      :option:

      The namespace in which to look for the MinIO Tenant.

      Defaults to ``minio``.

   .. mc-cmd:: output
      :option:

      Outputs the generated ``YAML``-formatted specification objects to
      ``STDOUT`` for further customization. 
      
      :mc-cmd-option:`~kubectl minio tenant upgrade output` does 
      **not** upgrade the MinIO Tenant. Use ``kubectl apply -f <FILE>`` to
      manually upgrade the MinIO tenant using the generated file.


