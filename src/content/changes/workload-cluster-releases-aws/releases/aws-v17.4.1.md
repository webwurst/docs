---
# Generated by scripts/aggregate-changelogs. WARNING: Manual edits to this files will be overwritten.
aliases:
- /changes/tenant-cluster-releases-aws/releases/aws-v17.4.1/
changes_categories:
- Workload cluster releases for AWS
changes_entry:
  repository: giantswarm/releases
  url: https://github.com/giantswarm/releases/tree/master/aws/archived/v17.4.1
  version: 17.4.1
  version_tag: v17.4.1
date: '2022-07-07T11:08:42+00:00'
description: Release notes for AWS workload cluster release v17.4.1, published on
  07 July 2022, 11:08.
title: Workload cluster release v17.4.1 for AWS
---

This is a patch release bringing improvements to app-operator and chart-operator such as pod and container security contexts for PSS and more. It also contains a change in cert-manager to automatically upgrade stored custom resources stored in deprecated apiversions.

## Change details


### app-operator [6.1.0](https://github.com/giantswarm/app-operator/releases/tag/v6.1.0)

#### Changed
- Use downward API to set deployment env var `KUBERNETES_SERVICE_HOST` to `status.hostIP`.
- Change `initialBootstrapMode` configuration value to `bootstrapMode`.
- Tighten pod and container security contexts for PSS restricted policies.
#### Added
- Allow to set api server pod port when enabling `initialBootstrapMode`.



### chart-operator [2.25.0](https://github.com/giantswarm/chart-operator/releases/tag/v2.25.0)

#### Changed
- Tighten pod and container security contexts for PSS restricted policies.
- Use downward API to set deployment env var `KUBERNETES_SERVICE_HOST` to `status.hostIP`.
- Change `initialBootstrapMode` configuration value to `bootstrapMode`.
- Use private Helm client for installing app-operators from control-plane-test-catalog
#### Added
- Allow to set api server pod port when enabling `initialBootstrapMode`.



### cert-manager [2.15.1](https://github.com/giantswarm/cert-manager-app/releases/tag/v2.15.1)

#### Fixed
- Automatically try to execute `cmctl upgrade migrate-api-version` in crd install job to upgrade stored apiversions ([#245](https://github.com/giantswarm/cert-manager-app/pull/245))



### vertical-pod-autoscaler [2.4.1](https://github.com/giantswarm/vertical-pod-autoscaler-app/releases/tag/v2.4.1)

#### Fixed
- Correct selector in admission controller PDB
