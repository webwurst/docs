---
# Generated by scripts/aggregate-changelogs. WARNING: Manual edits to this files will be overwritten.
changes_categories:
- Tenant Cluster Releases for AWS
changes_entry:
  repository: giantswarm/releases
  url: https://github.com/giantswarm/releases/tree/master/aws/v9.3.9
  version: 9.3.9
  version_tag: v9.3.9
date: '2020-10-20T10:00:00+00:00'
description: Release notes for AWS release v9.3.9, published on 20 October 2020, 10:00
title: Tenant Cluster Release v9.3.9 for AWS
---

**If you are upgrading from 9.3.8, upgrading to this release will not roll your nodes.**

This patch release fixes a problem causing the accidental deletion and reinstallation of Preinstalled Apps (such as CoreDNS) in 9.x.x tenant clusters.

Please upgrade all older clusters to this version in order to prevent possible downtime. 

## Change details

### cluster-operator [0.23.18](https://github.com/giantswarm/cluster-operator/blob/legacy/CHANGELOG.md#02318---2020-10-21)

### Changed

- Get app-operator version from releases CR. 

### Fixed

- Remove all chartconfig migration logic that caused accidental deletion and is no longer needed.

### chart-operator [0.13.2](https://github.com/giantswarm/chart-operator/blob/helm2/CHANGELOG.md#v0132-2020-06-23)

### Changed

- Calculating md5sum from Chart go struct.
- Add metrics for Helm releases with a mismatched namespace.