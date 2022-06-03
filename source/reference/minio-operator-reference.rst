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
deploying and managing MinIO deployments ("MinIO tenant") on a Kubernetes
cluster. 

The MinIO Operator requires familiarity with interacting with a Kubernetes
cluster, including but not limited to using the ``kubectl`` command line tool
and interacting with Kubernetes ``YAML`` objects. Users who would prefer a more
simplified experience should use the :ref:`minio-kubectl-plugin` for deploying
and managing MinIO tenants.

The MinIO Kubernetes Operator |operator-version-stable| requires Kubernetes
1.19.0 or later.

The MinIO Operator installs a 
:kube-docs:`Custom Resource Document (CRD)
<concepts/extend-kubernetes/api-extension/custom-resources/#customresourcedefinitions>` 
to support describing MinIO tenants as a Kubernetes 
:kube-docs:`object 
<concepts/overview/working-with-objects/kubernetes-objects/>`. See the
MinIO Operator :minio-git:`CRD Reference <operator/blob/master/docs/crd.adoc>`
for complete documentation on the MinIO CRD.

Deploying the MinIO Operator
----------------------------

The following operations deploy the MinIO operator using ``kustomize``
templates. Users who would prefer a more simplified deployment experience
that does *not* require familiarity with ``kustomize`` should use the
:ref:`minio-kubectl-plugin` for deploying and managing MinIO Tenants.

.. tab-set::

   .. tab-item:: krew

      Use the following command to install the MinIO Operator *and* 
      MinIO Kubernetes Plugin using the 
      `Kubernetes krew <https://github.com/kubernetes-sigs/krew>` plugin 
      manager. See the 
      `krew installation documentation 
      <https://krew.sigs.k8s.io/docs/user-guide/setup/install/>`__ for 
      instructions on installing ``krew``.

      .. code-block:: shell
         :class: copyable

         kubectl krew update
         kubectl krew install minio

      Run the following command to initialize the Operator. The MinIO 
      Operator installs to the ``minio-operator`` namespace by default. 

      .. code-block:: shell
         :class: copyable

         kubectl minio init

   .. tab-item:: kubectl

      Use the following command to deploy the MinIO Operator using 
      ``kubectl`` and ``kustomize`` templates:

      .. code-block::
         :class: copyable
         :substitutions:

         kubectl apply -k github.com/minio/operator/\?ref\=|minio-operator-latest-version|

   .. tab-item:: kustomize


      Use :github:`kustomize <kubernetes-sigs/kustomize>` to deploy the
      MinIO Operator using ``kustomize`` templates:

      .. code-block::
         :class: copyable
         :substitutions:

         kustomize build github.com/minio/operator/\?ref\=|minio-operator-latest-version| \
            > minio-operator-|minio-operator-latest-version|.yaml
