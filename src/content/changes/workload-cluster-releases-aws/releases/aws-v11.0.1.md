---
# Generated by scripts/aggregate-changelogs. WARNING: Manual edits to this files will be overwritten.
aliases:
- /changes/tenant-cluster-releases-aws/releases/aws-v11.0.1/
changes_categories:
- Workload cluster releases for AWS
changes_entry:
  repository: giantswarm/releases
  url: https://github.com/giantswarm/releases/tree/master/aws/archived/v11.0.1
  version: 11.0.1
  version_tag: v11.0.1
date: '2020-02-05T12:00:00+00:00'
description: Release notes for AWS workload cluster release v11.0.1, published on
  05 February 2020, 12:00.
title: Workload cluster release v11.0.1 for AWS
---

This release fixes an issue with network traffic between node pools in 10.x and
11.x clusters reported on the 5th of February 2020. **To prevent encountering
network traffic problems between node pools, please upgrade to this release.**



### aws-operator [v8.1.1](https://github.com/giantswarm/aws-operator/releases/tag/v8.1.1)
- Fix AWS resource tags.
- Allow network traffic between Node Pools.
