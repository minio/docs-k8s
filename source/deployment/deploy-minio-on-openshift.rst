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

The MinIO Kubernetes Operator is available in Red Hat® OpenShift® Container
Platform 4.7+ through the :openshift-docs:`OperatorHub
<operators/admin/olm-adding-operators-to-cluster.html>`.

Red Hat® OpenShift® is an enterprise-ready Kubernetes container platform with
full-stack automated operations to manage hybrid cloud, multi-cloud, and edge
deployments. OpenShift includes an enterprise-grade Linux operating system,
container runtime, networking, monitoring, registry, and authentication and
authorization solutions. 

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

The MinIO Kubernetes Operator is available through OperatorHub on OpenShift 
4.7+.

For older versions of OpenShift, use the generic 
:ref:`deploy-operator-kubernetes` procedure.

Administrator Access
~~~~~~~~~~~~~~~~~~~~

Installation of operators through OperatorHub is restricted to OpenShift cluster
administrators (``cluster-admin`` privileges). 

OpenShift ``oc`` CLI
~~~~~~~~~~~~~~~~~~~~

:openshift-docs:`Download and Install 
<cli_reference/openshift_cli/getting-started-cli.html>`
the OpenShift :abbr:`CLI (command-line interface)` ``oc`` for use in this 
procedure.

Procedure
---------

1) Select the MinIO Operator in OperatorHub
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Log into the OpenShift Web Console as a user with ``cluster-admin`` 
privileges. 

From the :guilabel:`Administrator` panel, select :guilabel:`Operators`, then
:guilabel:`OperatorHub`.

From the :guilabel:`OperatorHub` page, type "MinIO" into the :guilabel:`Filter`
text entry. Select the :guilabel:`MinIO Operator` tile from the search list.

.. image:: /images/openshift/minio-openshift-select-minio.png
   :align: center
   :width: 90%
   :class: no-scaled-link
   :alt: From the OperatorHub, search for MinIO, then select the MinIO Tile.

2) Install the MinIO Operator
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Selecting the :guilabel:`MinIO Operator` tile opens a panel for installing 
the Operator. Click :guilabel:`Install` to start the configuration walkthrough.

.. image:: /images/openshift/minio-openshift-operator-start-install.png
   :align: center
   :width: 90%
   :class: no-scaled-link
   :alt: Click the MinIO tile to open the description panel, then click Install.

The :guilabel:`Install Operator` page provides a walkthrough for configuring 
the MinIO Operator installation. 

.. image:: /images/openshift/minio-openshift-operator-installation.png
   :align: center
   :width: 90%
   :class: no-scaled-link
   :alt: Complete the Operator Installation Walkthrough

See the :openshift-docs:`Operator Installation Documentation 
<operators/admin/olm-adding-operators-to-cluster.html#olm-installing-from-operatorhub-using-web-console_olm-adding-operators-to-a-cluster>`
:guilabel:`Step 5` for complete descriptions of each displayed option.

Click :guilabel:`Install` to start the installation procedure. The web 
console displays a widget for tracking the installation progress.

.. image:: /images/openshift/minio-openshift-operator-installation-progress.png
   :align: center
   :width: 90%
   :class: no-scaled-link
   :alt: Wait for Installation to Complete.

Once installation completes, click :guilabel:`View Operator` to view the 
MinIO Operator page. 

3) Next Steps
~~~~~~~~~~~~~

You can create a MinIO Tenant using any of the following methods:

Deploy via Command Line
  Using the ``oc`` commandline tool, use the ``oc minio tenant create`` command 
  to create a new tenant. Use the :ref:`deploy-minio-tenant-commandline` 
  procedure for guidance, substituting ``kubectl minio`` with ``oc minio``.

  If the local host does not have the MinIO Kubernetes Plugin installed,
  download the latest :minio-git:`kubectl-minio release <operator/releases/>`
  for your system architecture. Set the file permissions to allow executing the
  binary and move it to your system ``$PATH``. 
  
  The following code downloads the latest stable version |operator-version-stable|
  for ARM64 Linux distributions, sets the binary to executable, and copies it to
  the system ``$PATH``:  
  
  .. parsed-literal::
     :class: copyable
  
     wget https://github.com/minio/operator/releases/download/v4.1.1/kubectl-minio_4.1.1_linux_amd64
     chmod ~x kubectl-minio
     mv kubectl-minio /usr/local/bin/
  
  Replace the ``wget`` URL with the appropriate executable from the 
  latest stable :minio-git:`release <operator/releases/>`.
      
Deploy via OperatorHub
  Using the MinIO Operator page in the Web Console. From 
  :guilabel:`Operators`, select :guilabel:`Installed Operators`, then 
  :guilabel:`MinIO Operator`.

  Click the :guilabel:`Create instance` on the :guilabel:`Tenant` card to 
  create a new MinIO Tenant.


