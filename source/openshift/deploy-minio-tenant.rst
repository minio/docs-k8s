.. _deploy-minio-tenant-redhat-openshift:

=========================================
Deploy a MinIO Tenant on RedHat OpenShift
=========================================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

You can deploy and manage MinIO Tenants through OpenShift 4.7+ using the 
MinIO Kubernetes Operator. This procedure documents deploying a MinIO Tenant
using the OpenShift web console.

This procedure *requires* installing the MinIO Operator into the OpenShift 
Operator Hub. See :ref:`deploy-operator-openshift` for more complete 
instructions.

This documentation assumes familiarity with all referenced Kubernetes and
OpenShift concepts, utilities, and procedures. While this documentation *may*
provide guidance for configuring or deploying Kubernetes-related or
OpenShift-related resources on a best-effort basis, it is not a replacement for
the official :kube-docs:`Kubernetes Documentation <>` and 
:openshift-docs:`OpenShift Container Platform 4.7+ Documentation 
<welcome/index.html>`.

Prerequisites
-------------

Create a Namespace
~~~~~~~~~~~~~~~~~~

MinIO supports deploying no more than one MinIO Tenant per namespace. 
Create the namespace *before* creating the Tenant.

Check Security Context Constraints
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The MinIO Operator deploys pods using the following default 
:kube-docs:`Security Context <tasks/configure-pod-container/security-context/>`
per pod:

.. code-block:: yaml
   :class: copyable

   securityContext:
     runAsUser: 1000
     runAsGroup: 1000
     runAsNonRoot: true
     fsGroup: 1000

Certain OpenShift 
:openshift-docs:`Security Context Constraints 
</authentication/managing-security-context-constraints.html>` 
limit the allowed UID or GID for a pod such that MinIO cannot deploy the Tenant
successfully. Ensure that the Project in which the Operator deploys the Tenant
has sufficient SCC settings that allow the default pod security context. The
following command returns the optimal value for the securityContext: 

.. code-block:: shell
   :class: copyable

   oc get namespace <namespace> \
   -o=jsonpath='{.metadata.annotations.openshift\.io/sa\.scc\.supplemental-groups}{"\n"}'

The command returns output similar to the following:
 
.. code-block:: shell

   1056560000/10000

Take note of this value before the slash for use in this procedure.

Create Kubernetes Secrets
~~~~~~~~~~~~~~~~~~~~~~~~~

MinIO Root User Secret
   Create an opaque secret with two data keys, where all values are
   base64-encoded. The MinIO Operator uses this secret for setting the root user
   permissions. The name of the secret must match the value specified to the
   ``spec.credsSecret.name`` key in the Tenant object specification.

   .. list-table::
      :stub-columns: 1
      :widths: 30 60
      :width: 100%

      * - ``accesskey``
        - The access key for the root user.

      * - ``secretkey``
        - The secret key for the root user.

   The value for both data keys should be a string that is long, secure, and
   unique. The following example YAML describes a secret that meets the stated
   requirements. The name ``minio-creds-secret`` assumes the tenant YAML has
   ``spec.credsSecret.name`` set to a matching value. Consider using the tenant
   name as a prefix to the secret name to ensure each tenant has its own secret
   key (e.g. ``minio-tenant-1`` should have its MinIO secret named
   ``minio-tenant-1-creds-secret``).

   .. code-block:: yaml

      apiVersion: v1
      kind: Secret
      metadata:
        name: minio-creds-secret
      type: Opaque
      data:
        accesskey: bWluaW8=
        secretkey: bWluaW8xMjM=

 
MinIO Console User Secret
   Create the opaque secret with four data keys, where all values are base64
   encoded. The MinIO Operator uses this secret for configuring the MinIO
   Console access to the MinIO tenant. The name of the secret must match the
   value specified to the console.consoleSecret.name key in the Tenant object
   specification.

   .. list-table::
      :stub-columns: 1
      :widths: 30 60
      :width: 100%

      * - ``CONSOLE_PBKDF_PASSPHRASE``
        - Passphrase used by the MinIO Console to encode generated
          authentication tokens.
          
      * - ``CONSOLE_PBKDF_SALT``
        - The salt used by the MinIO Console to encode generated authentication
          tokens.
          
      * - ``CONSOLE_ACCESS_KEY``
        - The access key for the MinIO Console administrative user
          
      * - ``CONSOLE_SECRET_KEY``
        - The corresponding secret key for the MinIO Console administrative user
          

The value for all data keys should be a string that is long, secure, and unique.
The following example YAML describes a secret that meets the stated
requirements. The name ``minio-console-secret`` assumes the tenant YAML has
``console.consoleSecret.name`` set to a matching value. Consider using the tenant
name as a prefix to the secret name to ensure each tenant has its own secret key
(e.g. ``minio-tenant-1`` should have its MinIO Console secret named
``minio-tenant-1-console-secret``)
 
.. code-block:: shell
   :class: copyable

   apiVersion: v1
   kind: Secret
   metadata:
     name: console-secret
   type: Opaque
   data:
     CONSOLE_PBKDF_PASSPHRASE: U0VDUkVU
     CONSOLE_PBKDF_SALT: U0VDUkVU
     CONSOLE_ACCESS_KEY: WU9VUkNPTlNPTEVBQ0NFU1M=
     CONSOLE_SECRET_KEY: WU9VUkNPTlNPTEVTRUNSRVQ=


Create Local Persistent Volumes and Storage Class
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

MinIO automatically generates one :kube-docs:`Persistent Volume Claim (PVC)
<concepts/storage/persistent-volumes/#persistentvolumeclaims>` for each volume
in the MinIO Tenant using a user-specified :kube-docs:`StorageClass
<concepts/storage/storage-classes/>`. 

- The cluster *must* have an equal number of
  :kube-docs:`Persistent Volumes (PV) <concepts/storage/volumes/>` to the number
  of volumes in the Tenant. MinIO *strongly recommends* using locally-attached
  storage to maximize performance and throughput.

- The storage class must have ``volumeBindingMode`` set to
  ``WaitForFirstConsumer``. 

You can skip this step if the cluster already has local ``PV`` resources and a
``StorageClass`` configured for use by the MinIO Tenant.

.. tab-set::

   .. tab-item:: Persistent Volume Example

      The following example YAML describes a local persistent volume that meets the 
      stated requirements:

      .. code-block:: yaml
         :class: copyable
         :emphasize-lines: 4, 12, 14, 22

         apiVersion: v1
         kind: PersistentVolume
         metadata:
            name: <PV-NAME>
         spec:
            capacity:
               storage: 1Ti
            volumeMode: Filesystem
            accessModes:
            - ReadWriteOnce
            persistentVolumeReclaimPolicy: Retain
            storage-class: local-storage
            local:
               path: </PATH/TO/DISK>
            nodeAffinity:
               required:
                  nodeSelectorTerms:
                  - matchExpressions:
                     - key: kubernetes.io/hostname
                        operator: In
                        values:
                        - <NODE-NAME>

      Replace values surrounded by angle brackets ``<VALUE>`` with
      the appropriate values for each node's locally attached
      disks. Create one PV with the necessary capacity for each
      volume the tenant requires. For example, a MinIO tenant
      using 16 disks requires 16 Persistent Volumes.

   .. tab-item:: Storage Class Example

      The following example YAML describes a storage class that meets the stated
      requirements. The name of the storage class must match the storage class applied
      to each persistent volume which the MinIO Tenant uses. 

      .. code-block:: yaml
         :class: copyable

         apiVersion: storage.k8s.io/v1
         kind: StorageClass
         metadata:
            name: local-storage
         provisioner: kubernetes.io/no-provisioner
         volumeBindingMode: WaitForFirstConsumer

      The ``StorageClass`` **must** have ``volumeBindingMode`` set to
      ``WaitForFirstConsumer`` to ensure correct binding of each pod's 
      :kube-docs:`Persistent Volume Claims (PVC) 
      <concepts/storage/persistent-volumes/#persistentvolumeclaims>` to the
      Node's local ``PV``.


Procedure
---------

1) Access the MinIO Operator Interface
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

You can find the MinIO Operator Interface from the :guilabel:`Operators`
left-hand navigation header.

1. Go to :guilabel:`Operators`, then :guilabel:`Installed Operators`. 

2. For the :guilabel:`Project` dropdown, select 
   :guilabel:`openshift-operators`.

3. Select :guilabel:`MinIO Operators` from the list of installed operators.

Click :guilabel:`Create Tenant` to begin the Tenant Creation process.

2) Create the Tenant
~~~~~~~~~~~~~~~~~~~~

The :guilabel:`Form View` provides a user interface for configuring the new 
MinIO Tenant.

.. image:: /images/openshift/minio-openshift-tenant-create-ui.png
   :align: center
   :width: 90%
   :class: no-scaled-link
   :alt: OpenShift Tenant Creation UI View

- Ensure the :guilabel:`Tenant Secret -> Name` is set to the name of the MinIO
  Root User Kubernetes Secret created as part of the prerequisites. 

- Ensure the :guilabel:`Console -> Console Secret -> Name` is set to the name of
  the MinIO Console Kubernetes Secret created as part of the prerequisites.

You can also use the YAML view to perform more granular configuration of the
MinIO Tenant. Refer to the :minio-git:`MinIO Custom Resource Definition
Documentation <operator/blob/master/docs/crd.adoc>` for guidance on setting
specific fields. MinIO also publishes examples for additional guidance in
creating custom Tenant YAML objects. Note that the OperatorHub YAML view
supports creating only the MinIO Tenant object. Do not specify any other objects
as part of the YAML input.

.. image:: /images/openshift/minio-openshift-tenant-create-yaml.png
   :align: center
   :width: 90%
   :class: no-scaled-link
   :alt: OpenShift Tenant Creation UI View

Changes to one view are reflected in the other. For example, you can make 
modifications in the :guilabel:`YAML View` and see those changes in the 
:guilabel:`Form View`.

.. admonition:: Security Context Configuration
   :class: note

   If your OpenShift cluster Security Context Configuration restricts the
   supported pod security contexts, open the YAML View and locate the
   ``spec.pools[n].securityContext`` and ``spec.console.securityContext``
   objects. Modify the ``securityContext`` settings to use a supported UID based
   on the SCC of your OpenShift Cluster.

Click :guilabel:`Create` to create the MinIO Tenant using the specified 
configuration. Use the credentials specified as part of the MinIO Root User 
secret to access the MinIO Server.

3) Connect to the Tenant
~~~~~~~~~~~~~~~~~~~~~~~~

For applications internal to the Kubernetes cluster, you can connect directly to
the MinIO service created by the Operator. Use 
``oc get svc --namespace NAMESPACE``
to retrieve the services for the tenant. 

For applications external to the Kubernetes cluster, you must configure 
:kube-docs:`Ingress </concepts/services-networking/ingress/>`
or a 
:kube-docs:`Load Balancer <concepts/services-networking/service/#loadbalancer>` 
to expose the MinIO Tenant services. Alternatively, you can use the 
``oc port-forward`` command to temporarily forward traffic from the local host 
to the MinIO Tenant.

- The ``minio`` service provides access to MinIO Object Storage operations.

- The ``*-console`` service provides access to the MinIO Console. The MinIO 
  Console supports GUI administration of the MinIO Tenant.