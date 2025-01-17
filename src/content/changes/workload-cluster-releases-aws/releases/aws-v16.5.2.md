---
# Generated by scripts/aggregate-changelogs. WARNING: Manual edits to this files will be overwritten.
aliases:
- /changes/tenant-cluster-releases-aws/releases/aws-v16.5.2/
changes_categories:
- Workload cluster releases for AWS
changes_entry:
  repository: giantswarm/releases
  url: https://github.com/giantswarm/releases/tree/master/aws/v16.5.2
  version: 16.5.2
  version_tag: v16.5.2
date: '2022-11-17T11:50:16+00:00'
description: Release notes for AWS workload cluster release v16.5.2, published on
  17 November 2022, 11:50.
title: Workload cluster release v16.5.2 for AWS
---

This is a patch release to add missing Elastic File System (EFS) IAM permissions. It also allows EFS CSI Driver to get the Instance Identity from the Instance Metadata Service (IMDS).

## Change details


### aws-operator [10.14.2](https://github.com/giantswarm/aws-operator/releases/tag/v10.14.2)

#### Fixed
- Added EFS policy to the ec2 instance role to allow to use the EFS driver out of the box



### kiam [2.5.1](https://github.com/giantswarm/kiam-app/releases/tag/v2.5.1)

#### Fixed
- Allow `whiteListRouteRegexp` to default to `/latest/*`.
