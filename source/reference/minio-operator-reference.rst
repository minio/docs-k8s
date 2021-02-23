:orphan:

.. _minio-operator:

=========================
MinIO Kubernetes Operator
=========================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

Overview
--------

The MinIO Kubernetes Operator ("MinIO Operator") brings native support for
deploying and managing MinIO deployments ("MinIO Tenant") on a Kubernetes
cluster. This documentation reflects the latest stable version of the MinIO 
Operator: |operator-version-stable|. 

The MinIO Operator requires familiarity with interacting with a Kubernetes
cluster, including but not limited to using the ``kubectl`` command line tool
and interacting with Kubernetes ``YAML`` objects. Creating a MinIO Tenant 
using the :minio-crd:`Operator CRD <>` requires knowledge and experience 
of creating Kubernetes ``YAML`` specifications. The 
:mc-cmd:`kubectl minio tenant create` command provides the  
:mc-cmd-option:`~kubectl minio tenant create output` argument for outputting 
a complete YAML object for deploying a MinIO Tenant. Consider using that 
output as a template for further customization of the MinIO Tenant using 
the Operator CRD.

Deploying the MinIO Operator
----------------------------

The following operations deploy the MinIO operator using ``kustomize``
templates. Users who would prefer a more simplified deployment experience
that does *not* require familiarity with ``kustomize`` should use the
:ref:`minio-kubectl-plugin` for deploying and managing MinIO Tenants.

.. tabs::

   .. tab:: ``kubectl``

      Use the following command to deploy the MinIO Operator using 
      ``kubectl`` and ``kustomize`` templates:

      .. code-block::
         :class: copyable
         :substitutions:

         kubectl apply -k github.com/minio/operator/\?ref\=|operator-version-stable|

   .. tab:: ``kustomize``


      Use :github:`kustomize <kubernetes-sigs/kustomize>` to deploy the
      MinIO Operator using ``kustomize`` templates:

      .. code-block::
         :class: copyable
         :substitutions:

         kustomize build github.com/minio/operator/\?ref\=|operator-version-stable| \
            > minio-operator-|operator-version-stable|.yaml



MinIO Tenant Object
-------------------

The following example Kubernetes ``YAML`` specification describes a MinIO Tenant
with the following resources.

- 4 ``minio`` server processes as a single Server Pool.
- 4 Volumes per server requesting 1Ti (Tebibyte) of storage each.
- 2 MinIO Console Service (MCS) processes.

Commented fields are optional and provide advanced customization of the Tenant
object. 

.. literalinclude:: /includes/git-operator/tenant.yaml

MinIO Operator ``YAML`` Quick Reference
---------------------------------------

The MinIO Operator adds a 
:kube-api:`CustomResourceDefinition 
<#customresourcedefinition-v1-apiextensions-k8s-io>` that extends the
Kubernetes Object API to support creating MinIO ``Tenant`` objects.

The following ``YAML`` block describes a MinIO Tenant object and its
top-level fields.

.. parsed-literal::

   apiVersion: minio.min.io/v2
   kind: Tenant
   metadata:
      metadata.name: minio
      metadata.namespace: <string>
      metadata.labels:
         app: minio
      metadata.annotations:
         prometheus.io/path: <string>
         prometheus.io/port: "<string>"
         prometheus.io/scrape: "<bool>"
   spec:
      spec.certConfig: <object>
      spec.console: <object>
      spec.credsSecret: <object>
      spec.env: <object>
      spec.externalCaCertSecret: <array>
      spec.externalCertSecret: <array>
      spec.externalClientCertSecret: <object>
      spec.image: minio/minio:latest
      spec.imagePullPolicy: IfNotPresent
      spec.kes: <object>
      spec.mountPath: <string>
      spec.podManagementPolicy: <string>
      spec.priorityClassName: <string>
      spec.requestAutoCert: <boolean>
      spec.securityContext: <object>
      spec.pools: <array>
      spec.serviceAccountName: <string>
      spec.subPath: <string>

See the :minio-crd:`Operator CRD <>` reference for complete documentation 
on each of the listed fields:



