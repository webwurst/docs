---
# Generated by scripts/aggregate-changelogs. WARNING: Manual edits to this files will be overwritten.
aliases:
- /changes/tenant-cluster-releases-aws/releases/aws-v10.1.0/
changes_categories:
- Workload cluster releases for AWS
changes_entry:
  repository: giantswarm/releases
  url: https://github.com/giantswarm/releases/tree/master/aws/archived/v10.1.0
  version: 10.1.0
  version_tag: v10.1.0
date: '2019-12-18T14:00:00+00:00'
description: Release notes for AWS workload cluster release v10.1.0, published on
  18 December 2019, 14:00.
title: Workload cluster release v10.1.0 for AWS
---

We are pleased to announce that the new release v10.1.0 contains the much anticipated Node Pools feature.

We want to remind you that the Node Pools enabled releases imply a breaking change. This means **existing clusters** below the 10.x.x major releases **are not upgradable**.
We will continue to support the 9.x.x releases with bug fixes and security patches for the next 6 months. During that timeframe please **ensure that you move all your workloads to new clusters**. We are at your service to assist with this.

*Please note*:

- With this release, we are _no longer_ rolling out NGINX Ingress Controller by default. It is now an optional App in the App Catalog and can be installed and configured on-demand. Or you can choose your own.

- The optional Ingress Controller currently does _not_ work in China due to the lack of Route53. We recommend customers in China to wait for our fixes for China to land in a soon to be released patch version before they start clusters with 10.x there.

The new NGINX Ingress Controller app includes all [previous updates](https://github.com/giantswarm/kubernetes-nginx-ingress-controller/blob/master/CHANGELOG.md)
as well as more configuration options. You can follow further development
through its [Changelog](https://github.com/giantswarm/nginx-ingress-controller-app/blob/master/CHANGELOG.md).

We hope you enjoy using Node Pools of which the documentation can be found here: https://docs.giantswarm.io/basics/nodepools/ including the other release changes which are listed below:

## Component changes:

## aws-operator 8.0.2 (from 5.5.0)

- Remove NGINX Ingress Controller [#1958](https://github.com/giantswarm/aws-operator/pull/1958)
- Clean Route53 records [#2030](https://github.com/giantswarm/aws-operator/pull/2030)
- Label nodes with operator version instead of release version [#2064](https://github.com/giantswarm/aws-operator/pull/2064)
- Use ClusterAPI types version 0.2.0 [#2080](https://github.com/giantswarm/aws-operator/pull/2080)

## cluster-operator 2.0.0 (from 0.21.0)

- Remove NGINX Ingress Controller
- Use ClusterAPI types

## cert-manager v0.9.0 ([GS v1.0.1](https://github.com/giantswarm/cert-manager-app/blob/master/CHANGELOG.md#v101))
- Added as a default app [Upstream Changelog](https://github.com/jetstack/cert-manager/releases/tag/v0.9.0)

## external-dns v0.5.11 ([GS v1.0.0](https://github.com/giantswarm/external-dns-app/blob/master/CHANGELOG.md#v100))
- Added as a default app [Upstream Changelog](https://github.com/kubernetes-sigs/external-dns/releases/tag/v0.5.11)

## kiam v3.4 ([GS v1.0.0](https://github.com/giantswarm/kiam-app/blob/master/CHANGELOG.md#v100))
- Added as a default app [Upstream Changelog](https://github.com/uswitch/kiam/releases/tag/v3.4)
