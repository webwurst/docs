---
# Generated by scripts/aggregate-changelogs. WARNING: Manual edits to this files will be overwritten.
aliases:
- /changes/tenant-cluster-releases-aws/releases/aws-v9.0.8/
changes_categories:
- Workload cluster releases for AWS
changes_entry:
  repository: giantswarm/releases
  url: https://github.com/giantswarm/releases/tree/master/aws/archived/v9.0.8
  version: 9.0.8
  version_tag: v9.0.8
date: '2020-07-21T15:00:00+00:00'
description: Release notes for AWS workload cluster release v9.0.8, published on 21
  July 2020, 15:00.
title: Workload cluster release v9.0.8 for AWS
---

**If you are upgrading from 9.0.7, upgrading to this release will not roll your nodes. It will only update the apps.**

This release updates NGINX Ingress Controller to the latest upstream release.
Most importantly, it includes a fix for a regression introduced in the previous upstream release related to `use-regex` and `rewrite` annotations.

**Note to SEs when upgrading from 8.5.0 or 9.0.0:** Existing customer automation or processes that manage the configuration of coredns, nginx-ingress-controller, or cluster-autoscaler must be modified in order to work with the changed location and format of the *-user-values configmaps. Please see our docs on [Tenant Cluster Release Versions: Versions that use the App Platform](https://docs.giantswarm.io/reference/release-versions/#versions-that-use-the-app-platform) for more details.

**Note for future 9.0.x releases:** Please include this note and the one above in all future 9.0.x releases.

Below, you can find more details on components that were changed with this release.

### nginx-ingress-controller v0.34.1 ([Giant Swarm app v1.7.2](https://github.com/giantswarm/nginx-ingress-controller-app/blob/master/CHANGELOG.md#v173-2020-07-16))

- Upgraded upstream ingress-nginx from v0.34.0 to v0.34.1 - [changelog](https://github.com/kubernetes/ingress-nginx/blob/master/Changelog.md#0341).
