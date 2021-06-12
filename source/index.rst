=====================================
MinIO Object Storage for Hybrid Cloud
=====================================

.. default-domain:: minio

MinIO is a Kubernetes-native object store designed to provide high performance
with an S3-compatible API. Administrators leveraging Kubernetes orchestration 
can deploy multi-tenant MinIO object storage within private and public cloud 
infrastructures (the "Hybrid Cloud"). Developers can rely on S3-compatibility 
when migrating applications from single-cloud or legacy infrastructures to 
MinIO-backed hybrid cloud object storage.

The :minio-git:`MinIO Operator <operator>` is a first-party Kubernetes extension
that adds a Custom Resource Definition for deploying MinIO Tenants onto
Kubernetes clusters. MinIO's Kubernetes offering includes the :ref:`MinIO Plugin
<minio-kubectl-plugin>` extension to the Kubernetes command line tool
:kube-docs:`kubectl <reference/kubectl/overview/>`. :mc:`kubectl minio` supports
deploying and managing MinIO Tenants on Kubernetes clusters.

This documentation reflects version |operator-version-stable| of the MinIO
Kubernetes Operator and Plugin. Both the Operator and Plugin require Kubernetes
1.19.0 or later. The Operator and Plugin v3.X.X releases required Kubernetes
1.17.0 or later. You must upgrade your Kubernetes cluster to 1.19.0 or later
to use Operator v4.0.0+.

This documentation assumes familiarity with all referenced Kubernetes
concepts, utilities, and procedures. While this documentation *may* 
provide guidance for configuring or deploying Kubernetes-related resources 
on a best-effort basis, it is not a replacement for the official
:kube-docs:`Kubernetes Documentation <>`.

Getting Started
---------------

- :ref:`deploy-operator-kubernetes`
- :ref:`deploy-minio-tenant-commandline`

.. toctree::
   :titlesonly:
   :hidden:

   /core-concepts/core-concepts
   /deployment/deploy-minio-operator
   /tenant-management/deploy-minio-tenant
   /tenant-management/manage-minio-tenant
   /security/security
   /reference/production-recommendations


