---
# Generated by scripts/aggregate-changelogs. WARNING: Manual edits to this files will be overwritten.
aliases:
- /changes/tenant-cluster-releases-azure/releases/azure-v12.1.2/
changes_categories:
- Workload cluster releases for Azure
changes_entry:
  repository: giantswarm/releases
  url: https://github.com/giantswarm/releases/tree/master/azure/archived/v12.1.2
  version: 12.1.2
  version_tag: v12.1.2
date: '2020-11-02T13:00:00+00:00'
description: Release notes for Azure workload cluster release v12.1.2, published on
  02 November 2020, 13:00.
title: Workload cluster release v12.1.2 for Azure
---

**Nodes will be rolled during upgrade to this version.**

This patch release prevents an issue with QPS (Queries per Second) limits introduced by Docker Hub.

**Note before upgrade:**

Please contact your Solution Engineer before upgrading. The upgrade is automated. However, it includes a data migration from Helm 2 release configmaps to Helm 3 release secrets, there are some pre-upgrade checks and we recommend monitoring the upgrade to ensure safety.

**Note for Solution Engineers:**

Please use [Upgrading tenant clusters to Helm 3](https://intranet.giantswarm.io/docs/dev-and-releng/helm/helm3-tenant-cluster-upgrade/) as a guide on the upgrade process for the checks and monitoring steps.

**Note for future 12.x.x releases:**

Please persist this note and the above, until all customers are on Azure v12.1.x and above.

## Change details

### azure-operator [4.3.0](https://github.com/giantswarm/azure-operator/compare/v4.2.0...v4.3.0)
- Pass dockerhub token for kubelet authorized image pulling.
- Update `k8scloudconfig` to v7.2.0, containing a fix for Docker Hub QPS.
