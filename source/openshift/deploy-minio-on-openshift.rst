.. _deploy-operator-openshift:

=========================================
Deploy MinIO Operator on RedHat OpenShift
=========================================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

Overview
--------

Red Hat® OpenShift® is an enterprise-ready Kubernetes container platform with
full-stack automated operations to manage hybrid cloud, multi-cloud, and edge
deployments. OpenShift includes an enterprise-grade Linux operating system,
container runtime, networking, monitoring, registry, and authentication and
authorization solutions. 

You can deploy the MinIO Kubernetes Operator through the 
:openshift-docs:`Red Hat® OpenShift® Container Platform 4.7+
<welcome/index.html>`. You can deploy and manage MinIO Tenants through OpenShift
after deploying the MinIO Operator. This procedure includes instructions for the
following deployment paths:

- Purchase and Deploy MinIO through the `RedHat Marketplace <https://marketplace.redhat.com/en-us/products/minio-hybrid-cloud-object-storage>`__.
- Deploy MinIO through the OpenShift `OperatorHub <https://operatorhub.io/operator/minio-operator>`__

After deploying the MinIO Operator into your OpenShift cluster, you can 
create and manage MinIO Tenants through the :openshift-docs:`OperatorHub
<operators/understanding/olm-understanding-operatorhub.html>` user interface.

This documentation assumes familiarity with all referenced Kubernetes and
OpenShift concepts, utilities, and procedures. While this documentation *may*
provide guidance for configuring or deploying Kubernetes-related or
OpenShift-related resources on a best-effort basis, it is not a replacement for
the official :kube-docs:`Kubernetes Documentation <>` and 
:openshift-docs:`OpenShift Container Platform 4.7+ Documentation 
<welcome/index.html>`.

Prerequisites
-------------

RedHat OpenShift 4.7+
~~~~~~~~~~~~~~~~~~~~~

The MinIO Kubernetes Operator is available  
starting with `OpenShift 4.7+ 
<https://docs.openshift.com/container-platform/4.7/welcome/index.html>`__.

For installing through the Red Hat Marketplace,the OpenShift cluster must be
registered for the Marketplace with the necessary namespaces. See 
`Register OpenShift cluster with Red Hat Marketplace
<https://marketplace.redhat.com/en-us/documentation/clusters>`__ for complete
instructions.

For older versions of OpenShift, use the generic 
:ref:`deploy-operator-kubernetes` procedure.

Administrator Access
~~~~~~~~~~~~~~~~~~~~

Installation of operators through the Red Hat Marketplace and the Operator Hub
is restricted to OpenShift cluster administrators (``cluster-admin``
privileges). This procedure requires logging into the Marketplace and/or
OpenShift with an account that has those privileges.

OpenShift ``oc`` CLI
~~~~~~~~~~~~~~~~~~~~

:openshift-docs:`Download and Install 
<cli_reference/openshift_cli/getting-started-cli.html>`
the OpenShift :abbr:`CLI (command-line interface)` ``oc`` for use in this 
procedure.

Procedure
---------

1) Access the MinIO Operator Installation
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Select the tab that corresponds to your preferred installation method:

.. tab-set::

   .. tab-item:: Red Hat Marketplace

      Open the `MinIO Red Hat Marketplace listing
      <https://marketplace.redhat.com/en-us/products/minio-hybrid-cloud-object-storage>`__
      in your browser. Click :guilabel:`Login` to log in with your Red Hat 
      Marketplace account.
      
      After logging in, click :guilabel:`Purchase` to purchase the MinIO
      Operator for your account. 

      After completing the purchase, click :guilabel:`Workplace` from the 
      top navigation and select :guilabel:`My Software`. 

      .. image:: /images/openshift/minio-openshift-marketplace-my-software.png
         :align: center
         :width: 90%
         :class: no-scaled-link
         :alt: From the Red Hat Marketplace, select Workplace, then My Software

      Click :guilabel:`MinIO Hybrid Cloud Object Storage` and select 
      :guilabel:`Install Operator` to start the Operator Installation 
      procedure in OpenShift.

   .. tab-item:: Red Hat OperatorHub

      Log into the OpenShift Web Console as a user with ``cluster-admin`` 
      privileges. 
      
      From the :guilabel:`Administrator` panel, select :guilabel:`Operators`,
      then :guilabel:`OperatorHub`.
      
      From the :guilabel:`OperatorHub` page, type "MinIO" into the
      :guilabel:`Filter` text entry. Select the :guilabel:`MinIO Operator` tile
      from the search list.
      
      .. image:: /images/openshift/minio-openshift-select-minio.png
         :align: center
         :width: 90%
         :class: no-scaled-link
         :alt: From the OperatorHub, search for MinIO, then select the MinIO Tile.

      Select the :guilabel:`MinIO Operator` tile, then click 
      :guilabel:`Install` to begin the installation.

2) Configure and Deploy the Operator
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The :guilabel:`Install Operator` page provides a walkthrough for configuring 
the MinIO Operator installation. 

.. image:: /images/openshift/minio-openshift-operator-installation.png
   :align: center
   :width: 90%
   :class: no-scaled-link
   :alt: Complete the Operator Installation Walkthrough

- For :guilabel:`Update channel`, select any of the available options.

- For :guilabel:`Installation Mode`, select 
  :guilabel:`All namespaces on the cluster`

- For :guilabel:`Installed Namespace`, select 
  :guilabel:`openshift-operators`

- For :guilabel:`Approval Strategy`, select the approval 
  strategy of your choice.

See the :openshift-docs:`Operator Installation Documentation 
<operators/admin/olm-adding-operators-to-cluster.html#olm-installing-from-operatorhub-using-web-console_olm-adding-operators-to-a-cluster>`
:guilabel:`Step 5` for complete descriptions of each displayed option.

Click :guilabel:`Install` to start the installation procedure. The web 
console displays a widget for tracking the installation progress.

.. image:: /images/openshift/minio-openshift-operator-installation-progress.png
   :align: center
   :width: 70%
   :class: no-scaled-link
   :alt: Wait for Installation to Complete.

Once installation completes, click :guilabel:`View Operator` to view the 
MinIO Operator page. 

3) Open the MinIO Operator Interface
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

You can find the MinIO Operator Interface from the :guilabel:`Operators`
left-hand navigation header.

1. Go to :guilabel:`Operators`, then :guilabel:`Installed Operators`. 

2. For the :guilabel:`Project` dropdown, select 
   :guilabel:`openshift-operators`.

3. Select :guilabel:`MinIO Operators` from the list of installed operators. 
   The :guilabel:`Status` column must read :guilabel:`Success` to access the 
   Operator interface.

4) Next Steps
~~~~~~~~~~~~~

After deploying the MinIO Operator, you can create a new MinIO Tenant.

To deploy a MinIO Tenant using OpenShift, see 
:ref:`deploy-minio-tenant-redhat-openshift`.

You can also deploy a Tenant using the MinIO Operator Console. See
:ref:`deploy-minio-tenant`. Substitute ``oc`` for ``kubectl`` throughout that
procedure.

If the local host does not have the MinIO Kubernetes Plugin installed,
download the latest :minio-git:`kubectl-minio release <operator/releases/>`
for your system architecture. Set the file permissions to allow executing the
binary and move it to your system ``$PATH``. 

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

.. toctree::
   :titlesonly:
   :hidden:

   /openshift/deploy-minio-tenant
