.. _deploy-operator-kubernetes:

====================================
Deploy MinIO Operator on Kubernetes
====================================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

Overview
--------

MinIO is a Kubernetes-native high performance object store with an S3-compatible
API. The MinIO Kubernetes Operator supports deploying MinIO Tenants onto private
and public cloud infrastructures ("Hybrid" Cloud).

The following procedure installs the latest stable version
(|operator-version-stable|) of the MinIO Operator and MinIO Plugin on Kubernetes
infrastructure:

- The MinIO Operator installs a :kube-docs:`Custom Resource Document (CRD)
  <concepts/extend-kubernetes/api-extension/custom-resources/#customresourcedefinitions>`
  to support describing MinIO tenants as a Kubernetes :kube-docs:`object
  <concepts/overview/working-with-objects/kubernetes-objects/>`. See the MinIO
  Operator :minio-git:`CRD Reference <operator/blob/master/docs/crd.adoc>` for
  complete documentation on the MinIO CRD.

- The MinIO Kubernetes Plugin brings native support for deploying and managing
  MinIO tenants on a Kubernetes cluster using the :mc:`kubectl minio` command. 

This procedure assumes a generic Kubernetes environment. The following
procedures provide more specific guidance for certain Kubernetes providers:

- :ref:`Install MinIO Operator for Openshift <deploy-operator-openshift>`

This documentation assumes familiarity with all referenced Kubernetes
concepts, utilities, and procedures. While this documentation *may* 
provide guidance for configuring or deploying Kubernetes-related resources 
on a best-effort basis, it is not a replacement for the official
:kube-docs:`Kubernetes Documentation <>`.

Prerequisites
-------------

Kubernetes Version 1.19.0
~~~~~~~~~~~~~~~~~~~~~~~~~

Starting with v4.0.0, the MinIO Operator and MinIO Kubernetes Plugin require
Kubernetes 1.19.0 and later. The Kubernetes infrastructure *and* the 
``kubectl`` CLI tool must have the same version of 1.19.0+.

Prior to v4.0.0, the MinIO Operator and Plugin required Kubernetes 1.17.0. You 
*must* upgrade your Kubernetes infrastructure to 1.19.0 or later to use 
the MinIO Operator or Plugin v4.0.0 or later.

Kubernetes TLS Certificate API
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The MinIO Operator automatically generates TLS Certificate Signing Requests
(CSR) and uses the Kubernetes ``certificates.k8s.io`` 
:kube-docs:`TLS certificate management API 
<tasks/tls/managing-tls-in-a-cluster/>` to create signed TLS certificates.

The MinIO Operator therefore *requires* that the Kubernetes 
``kube-controller-manager`` configuration include the following 
:kube-docs:`configuration settings 
<reference/command-line-tools-reference/kube-controller-manager/#options>`:

- ``--cluster-signing-key-file`` - Specify the PEM-encoded RSA or ECDSA private
  key used to sign cluster-scoped certificates.

- ``--cluster-signing-cert-file`` - Specify the PEM-encoded x.509 Certificate
  Authority certificate used to issue cluster-scoped certificates.

The Operator cannot complete initialization if the Kubernetes cluster is 
not configured to respond to a generated CSR. Certain Kubernetes 
providers do not specify these configuration values by default. 

To verify whether the ``kube-controller-manager`` has the required 
settings, use the following command. Replace ``$CLUSTER-NAME`` with the name 
of the Kubernetes cluster:

.. code-block:: shell
   :class: copyable

   kubectl get pod kube-controller-manager-$CLUSTERNAME-control-plane \ 
     -n kube-system -o yaml

Confirm that the output contains the highlighted lines. The output of 
the example command above may differ from the output in your terminal:

.. code-block:: shell
   :emphasize-lines: 12,13

    spec:
    containers:
    - command:
        - kube-controller-manager
        - --allocate-node-cidrs=true
        - --authentication-kubeconfig=/etc/kubernetes/controller-manager.conf
        - --authorization-kubeconfig=/etc/kubernetes/controller-manager.conf
        - --bind-address=127.0.0.1
        - --client-ca-file=/etc/kubernetes/pki/ca.crt
        - --cluster-cidr=10.244.0.0/16
        - --cluster-name=my-cluster-name
        - --cluster-signing-cert-file=/etc/kubernetes/pki/ca.crt
        - --cluster-signing-key-file=/etc/kubernetes/pki/ca.key
    ...

.. important::

   The MinIO Operator automatically generates TLS certificates for all 
   MinIO Tenant pods using the specified Certificate Authority (CA).
   Clients external to the Kubernetes cluster must trust the  
   Kubernetes cluster CA to connect to the MinIO Operator or MinIO Tenants. 

   Clients which cannot trust the Kubernetes cluster CA can try disabling TLS 
   validation for connections to the MinIO Operator or a MinIO Tenant. 

   Alternatively, you can generate x.509 TLS certificates signed by a known
   and trusted CA and pass those certificates to MinIO Tenants. 
   See :ref:`minio-tls-user-generated` for more complete documentation.

Procedure
---------

1) Install the MinIO Kubernetes Operator
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

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

2) Initialize the MinIO Kubernetes Operator
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Run the :mc:`kubectl minio init` command to initialize the MinIO Operator:

.. code-block:: shell
   :class: copyable

   kubectl minio init

The command initializes the MinIO Operator with the following default settings:

- Deploy the Operator into the ``minio-operator`` namespace. 
  Specify the :mc-cmd-option:`kubectl minio init namespace` argument to 
  deploy the operator into a different namespace.

- Use ``cluster.local`` as the cluster domain when configuring the DNS hostname
  of the operator. Specify the 
  :mc-cmd-option:`kubectl minio init cluster-domain` argument to set a 
  different :kube-docs:`cluster domain 
  <tasks/administer-cluster/dns-custom-nameservers/>` value.

.. important::

   Document all arguments used when initializing the MinIO Operator.

3) Validate the Operator Installation
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

To verify the installation, run the following command:

.. code-block:: shell
   :class: copyable

   kubectl get all --namespace minio-operator

If you initialized the Operator with a custom namespace, replace 
``minio-operator`` with that namespace.

The output resembles the following:

.. code-block:: shell

   NAME                                  READY   STATUS    RESTARTS   AGE
   pod/console-59b769c486-cv7zv          1/1     Running   0          81m
   pod/minio-operator-7976b4df5b-rsskl   1/1     Running   0          81m

   NAME               TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)             AGE
   service/console    ClusterIP   10.105.218.94    <none>        9090/TCP,9443/TCP   81m
   service/operator   ClusterIP   10.110.113.146   <none>        4222/TCP,4233/TCP   81m

   NAME                             READY   UP-TO-DATE   AVAILABLE   AGE
   deployment.apps/console          1/1     1            1           81m
   deployment.apps/minio-operator   1/1     1            1           81m

   NAME                                        DESIRED   CURRENT   READY   AGE
   replicaset.apps/console-59b769c486          1         1         1       81m
   replicaset.apps/minio-operator-7976b4df5b   1         1         1       81m

4) Next Steps
~~~~~~~~~~~~~

- :ref:`deploy-minio-tenant`
- :ref:`deploy-minio-tenant-commandline`