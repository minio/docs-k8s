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

.. image:: /images/operator-console/operator-dashboard.png
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

.. image:: /images/operator-console/operator-dashboard.png
   :align: center
   :width: 70%
   :class: no-scaled-link
   :alt: MinIO Operator Console

You can :ref:`deploy a MinIO Tenant <deploy-minio-tenant>` through the 
Operator Console.

The Operator Console automatically detects any MinIO Tenants 
deployed on the cluster, whether provisioned through the Operator Console 
or through the :ref:`MinIO Kubernetes Plugin <deploy-minio-tenant-commandline>`.

For each listed tenant, select :guilabel:`MANAGE` to open an in-browser
view of that tenant's MinIO Console. You can use this view to directly manage
the tenant through the Operator UI.

.. image:: /images/operator-console/operator-manage-tenant.png
   :align: center
   :width: 70%
   :class: no-scaled-link
   :alt: MinIO Operator Tenant Console

Select :guilabel:`VIEW` to view the Tenant details and configurations. 
You can modify, expand, upgrade, and delete the Tenant from this view.

.. image:: /images/operator-console/operator-tenant-view.png
   :align: center
   :width: 70%
   :class: no-scaled-link
   :alt: MinIO Operator Tenant View

Persistent Volume Management
----------------------------

The MinIO Operator Console includes an interface for managing 
storage volumes and volume claims associated to MinIO Tenants. 

- The :guilabel:`Volumes` tab displays all Persistent Volume Claims generated
  for Tenants managed by the MinIO Operator.


- The :guilabel:`Drives` tab displays any locally attached drives that are
  currently managed or eligible for management by :minio-git:`MinIO DirectCSI
  <direct-csi>`.
  

MinIO DirectCSI supports dynamic provisioning of persistent volumes from 
locally-attached storage. DirectCSI manages allocation of volumes based 
on storage capacity and schedules pods to run on nodes which have the 
most available capacity. See the :minio-git:`DirectCSI Documentation
<direct-csi/blob/master/README.md>` for installation and configuration
instructions.

You can use DirectCSI for any Kubernetes service that can take advantage of
dynamically provisioned locally-attached storage by specifying the
``direct-csi-min-io`` :kube-docs:`StorageClass
<concepts/storage/storage-classes/>` as part of the Persistent Volume Claim.

