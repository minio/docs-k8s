=========================
Configure Tenant Security
=========================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

Identity and Access Management
------------------------------

MinIO enforces authentication and authorization for all incoming requests. 
Administrators can use the MinIO Console *or* an S3-compatible command-line tool 
such as ``mc`` for configuring IAM on a MinIO Tenant.

These pages document MinIO IAM in context of MinIO Tenants on Kubernetes. 
See :baremetal:`MinIO Identity and Access Management 
<security/IAM/identity-access-management>` for more complete documentation.

.. _minio-k8s-identity-management:

Identity Management
~~~~~~~~~~~~~~~~~~~

A MinIO *user* is an identity that includes at minimum credentials 
consisting of an Access Key and Secret Key. MinIO requires all incoming 
requests include credentials which match an existing user. 

If MinIO successfully *authenticates* an incoming request against either an 
internally-managed or externally-managed identity, MinIO then checks if the 
identity is *authorized* to make the request. See 
:ref:`minio-k8s-access-management` for more information on authorization.

MinIO by default supports creating and managing users directly on the MinIO
Tenant. MinIO *also* supports configuring an External IDentity Providers (IDP),
such as Active Directory or OpenID, where MinIO can look up identities managed
by the external IDP as part of authentication. See :minio-git:`Operator Examples
<operator/tree/master/examples>` for examples implementations.

See :doc:`/tutorials/user-management` for tutorials on using the MinIO 
Console for performing user management on the MinIO Tenant. The following 
list includes common identity management procedures:

- :ref:`minio-k8s-create-new-user`
- :ref:`minio-k8s-change-user-password`
- :ref:`minio-k8s-create-service-account`

See :baremetal:`MinIO Users <security/IAM/iam-users>` for more complete 
documentation on MinIO Users.

.. _minio-k8s-access-management:

Access Management
~~~~~~~~~~~~~~~~~

After MinIO :ref:`authenticates <minio-k8s-identity-management>` a user, 
MinIO checks whether the specified user is *authorized* to perform the 
requested operation. MinIO uses Policy-Based Access Control (PBAC) for 
defining the actions and resources to which a client has access.

.. DIAGRAM: Client Request -> Identity -> Policy -> Allowed/Denied

MinIO policies are JSON documents with :iam-docs:`IAM-compatible syntax
<reference_policies.html>`. Each MinIO user can have *one* attached policy for
defining its scope of access. MinIO also supports creating *groups* of users,
where the users inherit the policy attached to the group. A group can have *one*
attached policy for defining the scope of access of its membership. 

A given user's access therefore consists of the set of both its explicitly 
attached policy *and* all inherited policies from its group membership. 
MinIO only processes the requested operation if the user's complete set of 
policies explicitly allow access to both the required actions *and* resources 
for that operation.

.. DIAGRAM: User Policy + Group Policy -> Request -> Allowed/Denied (flowchart?)

MinIO PBAC is deny-by-default, where MinIO denies access to any action or 
resource not *explicitly* allowed by the user's attached or inherited 
policies. MinIO *also* prioritizes Deny rules if two or more policies 
conflict over access to a given action or resource.

See :doc:`/tutorials/group-management` and :doc:`/tutorials/policy-management`
for tutorials on using the MinIO Console for performing group and policy
management respectively. The following list includes common access management 
procedures:

- :ref:`minio-k8s-create-new-group`
- :ref:`minio-k8s-change-group-membership`
- :ref:`minio-k8s-assign-group-policy`
- :ref:`minio-k8s-attach-user-policy`
- :ref:`minio-k8s-create-new-policy`

See :baremetal:`MinIO Groups <security/IAM/iam-groups>` and 
:baremetal:`MinIO Policies <security/IAM/iam-policies>` for more complete 
documentation on MinIO Groups and Policies.

Encryption and Key Management
-----------------------------

Network Encryption
~~~~~~~~~~~~~~~~~~

MinIO supports configuring TLS for encrypting data transmitted across the
network. The MinIO Operator automatically generates TLS x.509 certificates using
the Kubernetes 
:kube-docs:`certificates.k8s.io <tasks/tls/managing-tls-in-a-cluster/>` API. The
Kubernetes TLS API uses the Certificate Authority (CA) specified during cluster
bootstrapping when approving a Certificate Signing Request (CSR) issued through
the API. The MinIO Operator generates a certificate for each of the following 
domains:

``*.minio-hl.namespace.svc.cluster.local``
  Matches the hostname of each MinIO Pod in the Tenant.

``minio-hl.namespace.svc.cluster.local``
  Matches the headless service corresponding to all MinIO Pods in the 
  Tenant. 

``minio.namespace.cluster.local``
  Matches the service corresponding to the MinIO Tenant. Kubernetes pods
  typically use this service when performing operations against the MinIO
  Tenant.

``minio-console-svc.namespace.cluster.local``
  Matches the service corresponding to all MinIO Console pods in the 
  Tenant.

``*.minio-kes-hl-svc.namespace.svc.cluster.local``
  Matches the hostname of each MinIO KES Pod in the Tenant.

``minio-kes-hl-svc.namespace.svc.cluster.local``
  Matches the headless service corresponding to all MinIO KES Pods in the 
  Tenant.

.. note::

   The ``namespace`` and ``cluster.local`` fields will differ depending 
   on the Kubernetes Namespace in which the MinIO Tenant is deployed 
   *and* the Kubernetes cluster DNS settings.

Kubernetes pods by default do *not* automatically trust certificates generated
through the Kubernetes TLS API. For applications *internal* to the Kubernetes 
cluster (i.e. applications running on Pods in the cluster), you can manually 
add the Kubernetes CA to the Pod's system trust store using the 
`update-ca-certificates <https://manpages.ubuntu.com/manpages/xenial/man8/update-ca-certificates.8.html>`__ 
utility:

.. code-block:: shell
   :class: copyable
   
   cp /var/run/secrets/kubernetes.io/serviceaccount/ca.crt /usr/local/share/ca-certificates/
   update-ca-certificates

For applications *external* to the Kubernetes cluster, you must configure the
appropriate Ingress resource to route traffic to the MinIO Tenant. The
requirements for fully validated TLS connectivity depend on the specific Ingress
configuration. Ingress configuration is out of scope for this documentation. See
:kube-docs:`Kubernetes Ingress <concepts/services-networking/ingress/>` for more
complete guidance.

The MinIO Operator also supports deploying MinIO Tenants with user-generated
x.509 TLS certificates and Certificate Authorities (CA). MinIO supports the
:rfc:`Server Name Indication (SNI) <6066#section-3>` extension and allows
Administrators to specify multiple custom TLS certificates for supporting HTTPS
access to the Tenant through multiple domains. See
:ref:`minio-tls-user-generated` for more information.

Object Encryption
~~~~~~~~~~~~~~~~~

MinIO Tenants support Server-Side Encryption (SSE-S3) of objects using an
external Key Management Service (KMS) such as Hashicorp Vault, Thales 
CipherTrust (formerly Gemalto Keysecure), and Amazon KMS. 

See the MinIO :minio-git:`Operator Examples <operator/tree/master/examples>`
for guidance on creating MinIO Tenant object specifications with support for 
SSE-S3.

.. toctree::
   :titlesonly:
   :hidden:

   /tutorials/user-management
   /tutorials/group-management
   /tutorials/policy-management
   /tutorials/transport-layer-security