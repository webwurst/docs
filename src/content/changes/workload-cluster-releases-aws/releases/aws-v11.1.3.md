---
# Generated by scripts/aggregate-changelogs. WARNING: Manual edits to this files will be overwritten.
aliases:
- /changes/tenant-cluster-releases-aws/releases/aws-v11.1.3/
changes_categories:
- Workload cluster releases for AWS
changes_entry:
  repository: giantswarm/releases
  url: https://github.com/giantswarm/releases/tree/master/aws/archived/v11.1.3
  version: 11.1.3
  version_tag: v11.1.3
date: '2020-04-06T13:00:00+00:00'
description: Release notes for AWS workload cluster release v11.1.3, published on
  06 April 2020, 13:00.
title: Workload cluster release v11.1.3 for AWS
---

__Note:__ Upgrading to this release from any release prior v11.1.1 will cause a network downtime due to the network-related changes coming with the switch from Calico CNI to AWS CNI.

## aws-operator [v8.2.3](https://github.com/giantswarm/aws-operator/releases/tag/v8.2.3)

- Improve error handling ([aws-operator#2263](https://github.com/giantswarm/aws-operator/pull/2263), [errors#39](https://github.com/giantswarm/errors/pull/39)).

## cluster-operator [v2.1.7](https://github.com/giantswarm/cluster-operator/releases/tag/v2.1.7)

- Improve error handling ([cluster-operator#989](https://github.com/giantswarm/cluster-operator/pull/989), [errors#39](https://github.com/giantswarm/errors/pull/39)).
