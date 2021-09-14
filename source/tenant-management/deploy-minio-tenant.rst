.. _deploy-minio-tenant:

=====================
Deploy a MinIO Tenant
=====================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

This procedure documents deploying a MinIO Tenant using the 
MinIO Operator Console.

.. image:: /images/operator-console/operator-tenant-list.png
   :align: center
   :width: 70%
   :class: no-scaled-link
   :alt: MinIO Operator Console

The Operator Console provides a rich user interface for deploying and 
managing MinIO Tenants on Kubernetes infrastructure. Installing the 
MinIO :ref:`Kubernetes Operator <deploy-operator-kubernetes>` automatically
installs and configures the Operator Console.

This documentation assumes familiarity with all referenced Kubernetes
concepts, utilities, and procedures. While this documentation *may* 
provide guidance for configuring or deploying Kubernetes-related resources 
on a best-effort basis, it is not a replacement for the official
:kube-docs:`Kubernetes Documentation <>`.

Prerequisites
-------------

MinIO Operator |operator-version-stable|
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The Operator Console *requires* the MinIO Kubernetes Operator. This
procedure assumes the latest stable Operator version |operator-version-stable|.

See :ref:`deploy-operator-kubernetes` for complete documentation on deploying
the MinIO Operator.

MinIO Kubernetes Plugin |operator-version-stable|
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Run the following commands to install the MinIO Operator and Plugin using the 
Kubernetes ``krew`` plugin manager:

.. code-block:: shell
   :class: copyable

   kubectl krew update
   kubectl krew install minio

See the ``krew`` `installation documentation 
<https://krew.sigs.k8s.io/docs/user-guide/setup/install/>`__ for specific 
instructions.

You can also download the ``kubectl-minio`` plugin directly and install it to
your system ``PATH``. The following code downloads the latest stable version
|operator-version-stable| of the MinIO Kubernetes Plugin and installs it to the
system ``$PATH``:

.. code-block:: shell
   :substitutions:
   :class: copyable

   wget https://github.com/minio/operator/releases/download/v|operator-version-stable|/kubectl-minio_|operator-version-stable|_linux_amd64 -O kubectl-minio
   chmod +x kubectl-minio
   mv kubectl-minio /usr/local/bin/

Run the following command to verify installation of the plugin:

.. code-block:: shell
   :class: copyable

   kubectl minio version

The output should display the Operator version as |operator-version-stable|.

Kubernetes Version 1.19.0
~~~~~~~~~~~~~~~~~~~~~~~~~

Starting with v4.0.0, the MinIO Operator requires Kubernetes 1.19.0 and later.
The Kubernetes infrastructure *and* the ``kubectl`` CLI tool must have the same
version of 1.19.0+.

This procedure assumes the host machine has ``kubectl`` installed and 
configured with access to the target Kubernetes cluster. The host machine 
*must* have access to a web browser application.

Locally Attached Drives
~~~~~~~~~~~~~~~~~~~~~~~

MinIO *strongly recommends* using locally attached drives on each node intended
to support the MinIO Tenant. MinIO’s strict read-after-write and
list-after-write consistency model requires local disk filesystems (xfs, ext4,
etc.). MinIO also shows best performance with locally-attached drives.

MinIO automatically generates :kube-docs:`Persistent Volume Claims (PVC)
<concepts/storage/persistent-volumes/#persistentvolumeclaims>` as part of
deploying a MinIO Tenant. The Operator generates one PVC for each volume in the
tenant *plus* two PVC to support collecting Tenant Metrics and logs. For
example, deploying a Tenant with 16 volumes requires 18 (16 + 2) ``PV``.

This procedure uses the MinIO :minio-git:`DirectCSI <direct-csi>` driver to
automatically provision Persistent Volumes from locally attached drives to
support the generated PVC. See the :minio-git:`DirectCSI Documentation
<direct-csi/blob/master/README.md>` for installation and configuration
instructions.

For clusters which cannot deploy MinIO Direct CSI, 
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

1) Access the MinIO Operator Console
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

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
login page. You should see the :guilabel:`Tenants` page:

.. image:: /images/operator-console/operator-tenant-list.png
   :align: center
   :width: 70%
   :class: no-scaled-link
   :alt: MinIO Operator Console

Click the :guilabel:`+ Create Tenant` to start creating a MinIO Tenant.

2) Complete the :guilabel:`Name Tenant` Step
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The :guilabel:`i. Name Tenant` step contains configuration settings 
related to the Tenant :guilabel:`Name`, :guilabel:`Namespace`, and
:guilabel:`Storage Class`.

.. image:: /images/operator-console/create-new-tenant-1-name-tenant.png
   :align: center
   :width: 70%
   :class: no-scaled-link
   :alt: Add Tenant Step 1: Name Tenant

The specified :guilabel:`Namespace` must *not* contain any existing MinIO 
Tenants. Consider creating a new Namespace for the MinIO Tenant. 
You can create the namespace through the UI by entering the desired 
name and clicking the :guilabel:`+` icon.

This procedure assumes using the :minio-git:`DirectCSI <direct-csi>` 
storage class ``direct-csi-min-io``. See the :minio-git:`DirectCSI Documentation
<direct-csi/blob/master/README.md>` for installation and configuration
instructions.

The :guilabel:`Advanced Mode` toggle enables additional configuration 
options for the MinIO Tenant. This procedure provides a high level 
description of each of the advanced configuration sections.

Click :guilabel:`Next` to proceed.

3) Complete the :guilabel:`Configure` Step
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The :guilabel:`ii. Configure` step contains configuration settings 
related to the MinIO Tenant. This step is only visible if you 
enabled :guilabel:`Advanced Mode` in step :guilabel:`i. Name Tenant`.

.. image:: /images/operator-console/create-new-tenant-2-configure.png
   :align: center
   :width: 70%
   :class: no-scaled-link
   :alt: Add Tenant Step 2: Configure

4) Complete the :guilabel:`Pod Affinity` Step
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The :guilabel:`iii. Pod Affinity` step contains configuration settings 
related to scheduling MinIO Tenant Pods. This step is only visible if you 
enabled :guilabel:`Advanced Mode` in step :guilabel:`i. Name Tenant`.

.. image:: /images/operator-console/create-new-tenant-3-pod-affinity.png
   :align: center
   :width: 70%
   :class: no-scaled-link
   :alt: Add Tenant Step 3: Pod Affinity

Select the type of affinity rules you want to apply to the MinIO Tenant. 
The default :guilabel:`Pod Anti-Affinity` ensures that no two MinIO 
pods deploy to the same worker node.

5) Complete the :guilabel:`Identity Provider` Step
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The :guilabel:`iv. Identity Provider` step contains configuration settings
related to MinIO :ref:`Identity and Access Management
<baremetal:minio-authentication-and-identity-management>`. This step is only
visible if you enabled :guilabel:`Advanced Mode` in step 
:guilabel:`i. Name Tenant`.

.. image:: /images/operator-console/create-new-tenant-4-identity-provider.png
   :align: center
   :width: 70%
   :class: no-scaled-link
   :alt: Add Tenant Step 4: Identity Provider

The default :guilabel:`Built-In` provides configuration settings for the MinIO
internal identity provider. See :ref:`MinIO Internal IDP
<baremetal:minio-internal-idp>` for more complete documentation.

You can also configure either an 
:ref:`OpenID Connect <baremetal:minio-external-identity-management-openid>` or
:ref:`Active Directory <baremetal:minio-external-identity-management-ad-ldap>`
service as an external identity manager. See the linked documentation for more
information on configuring MinIO for external identity management.

.. important:: 

   When configuring a MinIO Tenant to access a service external to the
   Kubernetes cluster, you **must** configure Ingress such that the MinIO Tenant
   has bidirectional network access to that service.

   The MinIO Operator does **not** configure Ingress as part of Tenant 
   deployment.

6) Complete the :guilabel:`Security` Step
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The :guilabel:`v. Security` step contains configuration settings related to
MinIO Transport Layer Security (TLS). This step is only visible if you enabled
:guilabel:`Advanced Mode` in step :guilabel:`i. Name Tenant`.

.. image:: /images/operator-console/create-new-tenant-5-security.png
   :align: center
   :width: 70%
   :class: no-scaled-link
   :alt: Add Tenant Step 5: Security

The MinIO Operator automatically generates TLS certificates using the 
Kubernetes ``certificates.k8s.io`` 
:kube-docs:`TLS certificate management API 
<tasks/tls/managing-tls-in-a-cluster/>`. You can disable this behavior 
by toggling :guilabel:`Enable AutoCert`.

You can provide one or more :guilabel:`Custom Certificates` for use by the 
MinIO Tenant. MinIO supports Server Name Indication (SNI) support for 
selecting which TLS certificate to respond with based on the hostname 
specified in a client request. The Operator automatically distributes the 
specified certificates to every server pod in the tenant.

Disabling :guilabel:`AutoCert` *and* specifying no 
:guilabel:`Custom Certificates` deploys the MinIO Tenant without TLS. 
Consider the security risks of allowing unsecured traffic before deploying
Tenants without TLS.

7) Complete the :guilabel:`Encryption` Step
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The :guilabel:`vi. Encryption` step contains configuration settings related to
:ref:`MinIO Server-Side Object Encryption <baremetal:minio-sse>`. This step is
only visible if you enabled :guilabel:`Advanced Mode` in step 
:guilabel:`i. Name Tenant`.

.. image:: /images/operator-console/create-new-tenant-6-encryption.png
   :align: center
   :width: 70%
   :class: no-scaled-link
   :alt: Add Tenant Step 6: Encryption

The Operator Console supports the following external Key Management Systems 
(KMS):

- Hashicorp Vault
- Thales CipherTrust (formerly Gemalto KeySecure)
- AWS KMS
- GCP Secrets Manager

For more complete documentation on the required fields, see 
:minio-git:`MinIO KES Guides <kes/wiki#guides>`.

.. important:: 

   When configuring a MinIO Tenant to access a service external to the
   Kubernetes cluster, you **must** configure Ingress such that the MinIO Tenant
   has bidirectional network access to that service.

   The MinIO Operator does **not** configure Ingress as part of Tenant 
   deployment.

8) Complete the :guilabel:`Tenant Size` Step
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The :guilabel:`vii. Tenant Size` step contains configuration settings related 
to the MinIO server pods deployed as part of the Tenant.

.. image:: /images/operator-console/create-new-tenant-7-tenant-size.png
   :align: center
   :width: 70%
   :class: no-scaled-link
   :alt: Add Tenant Step 7: Tenant Size

- The :guilabel:`Resource Allocation` section displays the resulting 
  compute configuration.

- The :guilabel:`Erasure Code Configuration` section displays the resulting
  :ref:`erasure code <baremetal:minio-erasure-coding>` configuration.

You can also use the 
MinIO `Erasure Code Calculator 
<https://min.io/product/erasure-code-calculator?ref=docs>`__ to help guide 
configuring the MinIO Tenant.

9) Complete the :guilabel:`Preview Configuration` Step
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The :guilabel:`viii. Preview Configuration` step displays a summary of 
the Tenant configuration.

.. image:: /images/operator-console/create-new-tenant-8-preview.png
   :align: center
   :width: 70%
   :class: no-scaled-link
   :alt: Add Tenant Step 8: Preview Configuration

Click :guilabel:`Create` to begin the Tenant creation process. You can return to
any previous section to modify the Tenant configuration before proceeding.

After clicking :guilabel:`Create`, the Operator Console displays the 
root credentials for the MinIO Tenant.

.. image:: /images/operator-console/create-new-tenant-9-credentials.png
   :align: center
   :width: 70%
   :class: no-scaled-link
   :alt: Tenant Root Credentials

Download and copy the credentials to a secure location. The Operator *never* 
displays these credentials again.

10) View Tenant Details
~~~~~~~~~~~~~~~~~~~~~~~

You can monitor the Tenant creation process from the 
:guilabel:`Tenants` view. The :guilabel:`State` column updates throughout the 
deployment process.

Tenant deployment can take several minutes to complete. Once the 
:guilabel:`State` reads as :guilabel:`Initialized`, click the Tenant to view 
its details.

.. image:: /images/operator-console/tenant-view.png
   :align: center
   :width: 70%
   :class: no-scaled-link
   :alt: Tenant View

Each tab provides additional details or configuration options for the 
MinIO Tenant. 

- :guilabel:`METRICS` - Displays metrics collected from the MinIO Tenant.
- :guilabel:`SECURITY` - Provides TLS-related configuration options.
- :guilabel:`POOLS` - Supports expanding the tenant by adding more Server Pools.
- :guilabel:`LICENSE` - Enter your `SUBNET <https://min.io/pricing?ref=docs>`__ 
  license.

11) Connect to the Tenant
~~~~~~~~~~~~~~~~~~~~~~~~~

The MinIO Operator creates services for the MinIO Tenant. Use the 
``kubectl get svc -n NAMESPACE`` command to review the deployed services:

.. code-block:: shell
   :class: copyable

   kubectl get svc -n minio-tenant-1

.. code-block:: shell

   NAME                               TYPE           CLUSTER-IP       EXTERNAL-IP   PORT(S)          AGE
   minio                              LoadBalancer   10.97.114.60     <pending>     443:30979/TCP    2d3h
   minio-tenant-1-console             LoadBalancer   10.106.103.247   <pending>     9443:32095/TCP   2d3h
   minio-tenant-1-hl                  ClusterIP      None             <none>        9000/TCP         2d3h
   minio-tenant-1-log-hl-svc          ClusterIP      None             <none>        5432/TCP         2d3h
   minio-tenant-1-log-search-api      ClusterIP      10.103.5.235     <none>        8080/TCP         2d3h
   minio-tenant-1-prometheus-hl-svc   ClusterIP      None             <none>        9090/TCP         7h39m

- The ``minio`` service corresponds to the MinIO Tenant service. Applications 
  should use this service for performing operations against the MinIO Tenant.
 
- The ``*-console`` service corresponds to the :minio-git:`MinIO Console 
  <console>`. Administrators should use this service for accessing the MinIO
  Console and performing administrative operations on the MinIO Tenant.

The remaining services support Tenant operations and are not intended for 
consumption by users or administrators.
 
By default each service is visible only within the Kubernetes cluster. 
Applications deployed inside the cluster can access the services using the 
``CLUSTER-IP``. 

Applications external to the Kubernetes cluster can access the services using
the ``EXTERNAL-IP``. This value is only populated for Kubernetes clusters 
configured for Ingress or a similar network access service. Kubernetes provides
multiple options for configuring external access to services. See the Kubernetes
documentation on :kube-docs:`Publishing Services (ServiceTypes)
<concepts/services-networking/service/#publishing-services-service-types>` and
:kube-docs:`Ingress <concepts/services-networking/ingress/>` for more complete
information on configuring external access to services.

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

.. toctree::
   :titlesonly:
   :hidden:

   /tenant-management/deploy-minio-tenant-using-commandline