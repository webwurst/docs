---
# Generated by scripts/aggregate-changelogs. WARNING: Manual edits to this files will be overwritten.
aliases:
- /changes/tenant-cluster-releases-aws/releases/aws-v12.7.2/
changes_categories:
- Workload cluster releases for AWS
changes_entry:
  repository: giantswarm/releases
  url: https://github.com/giantswarm/releases/tree/master/aws/v12.7.2
  version: 12.7.2
  version_tag: v12.7.2
date: '2021-04-26T13:51:04+00:00'
description: Release notes for AWS workload cluster release v12.7.2, published on
  26 April 2021, 13:51
title: Workload cluster release v12.7.2 for AWS
---

This release fixes an issue that can cause an IP conflict to occur in certain situations when a node pool is created.

## Change details


### aws-operator [9.3.1-ipam](https://github.com/giantswarm/aws-operator/releases/tag/v9.3.1-ipam)

- Fix IPAM conflicts when creating a node pool