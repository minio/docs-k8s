.. _minio-operator-console:

======================
MinIO Operator Console
======================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

The Operator Console provides a rich user interface for deploying and 
managing MinIO Tenants on Kubernetes infrastructure. Installing the 
MinIO :ref:`Kubernetes Operator <deploy-operator-kubernetes>` automatically
installs and configures the Operator Console.

.. image:: /images/operator-console/operator-tenant-list.png
   :align: center
   :width: 70%
   :class: no-scaled-link
   :alt: MinIO Operator Console

This page summarizes the functions available with the MinIO Operator Console.

Use the :mc-cmd:`kubectl minio proxy` command to temporarily forward 
traffic between the local host machine and the MinIO Operator Console:

.. code-block:: shell
   :class: copyable

   kubectl minio proxy

The command returns output similar to the following:

.. code-block:: shell

   Starting port forward of the Console UI.

   To connect open a browser and go to http://localhost:9090

   Current JWT to login: TOKEN

Open your browser to the specified URL and enter the JWT Token into the 
login page.

Tenant Management
-----------------

The MinIO Operator Console supports deploying, managing, and monitoring 
MinIO Tenants on the Kubernetes cluster.

.. image:: /images/operator-console/operator-tenant-list.png
   :align: center
   :width: 70%
   :class: no-scaled-link
   :alt: MinIO Operator Console

You can :ref:`deploy a MinIO Tenant <deploy-minio-tenant>` through the 
Operator Console.

The Operator Console automatically detects any MinIO Tenants 
deployed on the cluster, whether provisioned through the Operator Console 
or through the :ref:`MinIO Kubernetes Plugin <deploy-minio-tenant-commandline>`.

You can monitor each Tenant from the Console by clicking the 
:guilabel:`METRICS` tab:

.. image:: /images/operator-console/operator-tenant-metrics.png
   :align: center
   :width: 70%
   :class: no-scaled-link
   :alt: MinIO Operator Console Metrics

Persistent Volume Management
----------------------------

The MinIO Operator Console includes an interface for managing 
:minio-git:`MinIO DirectCSI <direct-csi>` drives and volumes. 
MinIO DirectCSI supports dynamic provisioning of persistent volumes from 
locally-attached storage. DirectCSI manages allocation of volumes based 
on storage capacity and schedules pods to run on nodes which have the 
most available capacity. See the :minio-git:`DirectCSI Documentation
<direct-csi/blob/master/README.md>` for installation and configuration
instructions.

If the Kubernetes cluster has DirectCSI installed, you can access the 
interface by clicking :guilabel:`Storage` in the left-navigation.

The :guilabel:`DRIVES` tab displays all locally-attached drives in the 
cluster and their current status. 

.. image:: /images/operator-console/direct-csi-drives.png
   :align: center
   :width: 70%
   :class: no-scaled-link
   :alt: MinIO Operator DirectCSI

The :guilabel:`VOLUMES` tab displays all DirectCSI-provisioned 
Persistent Volumes in the cluster.

.. image:: /images/operator-console/direct-csi-volumes.png
   :align: center
   :width: 70%
   :class: no-scaled-link
   :alt: MinIO Operator DirectCSI Volumes

You can use DirectCSI for any Kubernetes service that can take advantage of
dynamically provisioned locally-attached storage by specifying the
``direct-csi-min-io`` :kube-docs:`StorageClass
<concepts/storage/storage-classes/>` as part of the Persistent Volume Claim.