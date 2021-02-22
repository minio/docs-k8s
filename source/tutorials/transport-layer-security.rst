===================================
Configure TLS/SSL for MinIO Tenants
===================================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

Overview
--------

MinIO by default automatically generates self-signed TLS certificates for 
MinIO Tenant resources. This procedure documents configuring custom 
TLS x.509 certificates for use by the MinIO Tenant.

MinIO SNI support allows pods and services in the Tenant to use both 
auto-generated and custom certificates when establishing TLS connections. 
For example, you can deploy a Tenant where only services or pods accessed by 
external clients have custom certificates signed by a trusted Certificate 
Authority, while inter-Tenant TLS traffic continues to use the 
automatically generated self-signed certificates.

.. _minio-tls-user-generated:

User-Generated TLS Certificates for MinIO Object Storage
--------------------------------------------------------

The MinIO Operator supports specifying user-generated x.509 certificates for
establishing TLS connections. MinIO supports SNI where the pod or service can
select the appropriate x.509 certificate based on the hostname to which the
client is connecting. For example, consider an x.509 certificate with the
following Subject Alternative Name (SAN) DNS names:

- ``minio.example.net``
- ``*.minio.example.net``

Any MinIO pod or server with that certificate can select it in response to a 
client making a request against a matching domain.

The Operator also supports specifying Certificate Authorities (CA) used by the
MinIO Tenant for validating the x.509 certificates of external services.

See the :minio-git:`Operator Example on Tenants with Custom Certificates 
<operator/blob/master/examples/tenant-with-custom-ca-certs.yaml>` for an 
example Tenant specification object that implements custom certificates.

The following table lists a subset of MinIO Tenant object specification fields
for specifying user-generated x.509 certificates or Certificate Authorities
(CA):

.. list-table::
   :header-rows: 1
   :widths: 45 55
   :width: 100%

   * - Field
     - Description

   * - | :minio-crd:`spec.externalCaCertSecret <tenantspec-1>`
       | :minio-crd:`spec.console.externalCaCertSecret <consoleconfiguration>`
     - One or more Certificate Authority (CA) certificates used by Pods 
       in the MinIO Tenant when validating x.509 TLS certificates presented 
       by external services.

   * - | :minio-crd:`spec.externalCertSecret <tenantspec-1>`
       | :minio-crd:`spec.console.externalCertSecret <consoleconfiguration>`
     - One or more x.509 certificates used by Pods in the MinIO Tenant 
       for establishing TLS connections. The pod/service uses SNI to determine 
       which certificate to serve based on the requested hostname.

Create a Kubernetes Secret with type ``kubernetes.io/tls`` for each x.509
certificate or CA which you want to add to the MinIO Tenant. See 
:kube-docs:`Kubernetes Secrets </concepts/configuration/secret/>` for 
more complete documentation.
