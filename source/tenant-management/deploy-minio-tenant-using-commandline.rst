.. _deploy-minio-tenant-commandline:

============================================
Deploy a MinIO Tenant using the MinIO Plugin
============================================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

This procedure documents deploying a MinIO Tenant using the 
MinIO Kubernetes Plugin :mc:`kubectl minio`. 

Kubernetes administrators who require more specific customization of 
Tenants prior to deployment can use this tutorial to create a validated 
``yaml`` resource file for further modification.

The following procedure creates a MinIO tenant using the
:mc:`kubectl minio` plugin. This procedure assumes the 
MinIO Operator is installed on the Kubernetes cluster. See 
:ref:`deploy-operator-kubernetes` for complete documentation on deploying the 
MinIO Operator.

Prerequisites
-------------

MinIO Operator |operator-version-stable|
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The MinIO Kubernetes plugin *requires* the MinIO Kubernetes Operator. This
procedure assumes the latest stable Operator version |operator-version-stable|.

See :ref:`deploy-operator-kubernetes` for complete documentation on deploying
the MinIO Operator.

Kubernetes Version 1.19.0
~~~~~~~~~~~~~~~~~~~~~~~~~

Starting with v4.0.0, the MinIO Operator and MinIO Kubernetes Plugin require
Kubernetes 1.19.0 and later. The Kubernetes infrastructure *and* the 
``kubectl`` CLI tool must have the same version of 1.19.0+.

Locally Attached Drives
~~~~~~~~~~~~~~~~~~~~~~~

MinIO *strongly recommends* using locally attached drives on each node intended
to support the MinIO Tenant. MinIO’s strict read-after-write and
list-after-write consistency model requires local disk filesystems (xfs, ext4,
etc.). MinIO also shows best performance with locally-attached drives.

MinIO automatically generates :kube-docs:`Persistent Volume Claims (PVC)
<concepts/storage/persistent-volumes/#persistentvolumeclaims>` as part of
deploying a MinIO Tenant. The Operator generates one PVC for each volume in the
tenant. For example, deploying a Tenant with 16 volumes requires 16 ``PV``.

This procedure uses the MinIO :minio-git:`DirectCSI <direct-csi>` driver to
automatically provision Persistent Volumes from locally attached drives to
support the generated PVC. See the :minio-git:`DirectCSI Documentation
<direct-csi/blob/master/README.md>` for installation and configuration
instructions.

For clusters which cannot deploy MinIO Direct CSI, use 
:kube-docs:`Local Persistent Volumes <concepts/storage/volumes/#local>`.

The following tabs provide example YAML objects for a local persistent 
volume and a supporting 
:kube-docs:`StorageClass <concepts/storage/storage-classes/>`:

.. tabs::
   
   .. tab:: Local Persistent Volume

      The following YAML describes a :kube-docs:`Local Persistent Volume
      <concepts/storage/volumes/#local>`:

      .. include:: /includes/common/deploy-tenant-requirements.rst
         :start-after: start-local-persistent-volume
         :end-before: end-local-persistent-volume

      Replace values in brackets ``<VALUE>`` with the appropriate 
      value for the local drive.

   .. tab:: Storage Class

      The following YAML describes a 
      :kube-docs:`StorageClass <concepts/storage/storage-classes/>` that 
      meets the requirements for a MinIO Tenant:

      .. include:: /includes/common/deploy-tenant-requirements.rst
         :start-after: start-storage-class
         :end-before: end-storage-class

      The storage class *must* have ``volumeBindingMode: WaitForFirstConsumer``.
      Ensure all Persistent Volumes provisioned to support the MinIO Tenant 
      use this storage class.

Procedure
---------

1) Install the MinIO Plugin
~~~~~~~~~~~~~~~~~~~~~~~~~~~

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

You can skip this step if the MinIO Plugin is installed on the host machine.
Use :mc:`kubectl minio version <kubectl minio>` to check whether the plugin
is already installed.

2) Create a Namespace for the MinIO Tenant
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use the ``kubectl create namespace`` command to create a namespace for
the MinIO Tenant:

.. code-block:: shell
   :class: copyable

   kubectl create namespace minio-tenant-1

MinIO supports exactly *one* Tenant per namespace.

3) Create the MinIO Tenant
~~~~~~~~~~~~~~~~~~~~~~~~~~

Use the :mc-cmd:`kubectl minio tenant create` command to create the MinIO
Tenant.

The following example creates a 4-node MinIO deployment with a
total capacity of 16Ti across 16 drives.

.. code-block:: shell
   :class: copyable

   kubectl minio tenant create minio-tenant-1       \
     --servers                 4                    \
     --volumes                 16                   \
     --capacity                16Ti                 \
     --storage-class           direct-csi-min-io    \
     --namespace               minio-tenant-1

The following table explains each argument specified to the command:

.. list-table::
   :header-rows: 1
   :widths: 30 70
   :width: 100%

   * - Argument
     - Description

   * - :mc-cmd:`minio-tenant-1 <kubectl minio tenant create TENANT_NAME>`
     - The name of the MinIO Tenant which the command creates.

   * - :mc-cmd-option:`~kubectl minio tenant create servers`
     - The number of ``minio`` servers to deploy across the Kubernetes 
       cluster.

   * - :mc-cmd-option:`~kubectl minio tenant create volumes`
     - The number of volumes in the cluster. :mc:`kubectl minio` determines the
       number of volumes per server by dividing ``volumes`` by ``servers``.

   * - :mc-cmd-option:`~kubectl minio tenant create capacity`
     - The total capacity of the cluster. :mc:`kubectl minio` determines the 
       capacity of each volume by dividing ``capacity`` by ``volumes``.

   * - :mc-cmd-option:`~kubectl minio tenant create storage-class`
     - The Kubernetes ``StorageClass`` to use when creating each PVC. 
       This example uses the MinIO :minio-git:`DirectCSI <direct-csi>` 
       storage class.

   * - :mc-cmd-option:`~kubectl minio tenant create namespace`
     - The Kubernetes namespace in which to deploy the MinIO Tenant.

On success, the command returns the following:

- The administrative username and password for the Tenant. Store these 
  credentials in a secure location, such as a password protected 
  key manager. MinIO does *not* show these credentials again.

- The Service created for connecting to the MinIO Console. The Console
  supports administrative operations on the Tenant, such as configuring 
  Identity and Access Management (IAM) and bucket configurations.

- The Service created for connecting to the MinIO Tenant. Applications 
  should use this service for performing operations against the MinIO 
  Tenant.

4) Configure Access to the Service
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

:mc:`kubectl minio` creates a service for the MinIO Tenant and MinIO Console.
The output of :mc-cmd:`kubectl minio tenant create` includes the details for 
both services. You can also use ``kubectl get svc`` to retrieve the service 
name:

.. code-block:: shell
   :class: copyable

   kubectl get svc --namespace minio-tenant-1

The command returns output similar to the following:

.. code-block:: shell

   NAME                     TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)             AGE
   minio                    ClusterIP   10.109.88.X     <none>        443/TCP             137m
   minio-tenant-1-console   ClusterIP   10.97.87.X      <none>        9090/TCP,9443/TCP   129m
   minio-tenant-1-hl        ClusterIP   None            <none>        9000/TCP            137m

- The ``minio`` service corresponds to the MinIO Tenant service. Applications 
  should use this service for performing operations against the MinIO Tenant.

- The ``minio-tenant-1-console`` service corresponds to the MinIO Console. 
  Administrators should use this service for accessing the MinIO Console and 
  performing administrative operations on the MinIO Tenant.

- The ``minio-tenant-1-hl`` corresponds to a headless service used to 
  facilitate communication between Pods in the Tenant. 

By default each service is visible only within the Kubernetes cluster. 
Applications deployed inside the cluster can access the services using the 
``CLUSTER-IP``. For applications external to the Kubernetes cluster, 
you must configure the appropriate network rules to expose access to the 
service. Kubernetes provides multiple options for configuring external access 
to services. See the Kubernetes documentation on 
:kube-docs:`Publishing Services (ServiceTypes)
<concepts/services-networking/service/#publishing-services-service-types>`
and :kube-docs:`Ingress <concepts/services-networking/ingress/>`
for more complete information on configuring external access to services.

You can temporarily expose each service using the 
``kubectl port-forward`` utility. Run the following examples to forward 
traffic from the local host running ``kubectl`` to the services running inside 
the Kubernetes cluster.

.. tabs::

   .. tab:: MinIO Tenant

      .. code-block:: shell
         :class: copyable

         kubectl port-forward service/minio 443:443

   .. tab:: MinIO Console
   
      .. code-block:: shell
         :class: copyable

         kubectl port-forward service/minio-tenant-1-console 9443:9443
