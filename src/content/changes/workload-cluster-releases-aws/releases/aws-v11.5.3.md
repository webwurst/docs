---
# Generated by scripts/aggregate-changelogs. WARNING: Manual edits to this files will be overwritten.
aliases:
- /changes/tenant-cluster-releases-aws/releases/aws-v11.5.3/
changes_categories:
- Workload Cluster Releases for AWS
changes_entry:
  repository: giantswarm/releases
  url: https://github.com/giantswarm/releases/tree/master/aws/archived/v11.5.3
  version: 11.5.3
  version_tag: v11.5.3
date: '2020-08-27T13:00:00+00:00'
description: Release notes for AWS release v11.5.3, published on 27 August 2020, 13:00
title: Workload Cluster Release v11.5.3 for AWS
---

This release provides a new cluster-operator which fixes preventing release upgrade when reference id does not align with the G8sControlPlane id or MachineDeployment id and cluster status condition not being changed during cluster upgrade.

## Change details

### cluster-operator [2.3.4](https://github.com/giantswarm/cluster-operator/releases/tag/v2.3.4)

- Fix cluster status is not updated during cluster upgrade.
- Fix condition where reference id does not match with G8sControlplane or MachineDeployment.