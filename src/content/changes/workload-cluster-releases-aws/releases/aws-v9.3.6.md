---
# Generated by scripts/aggregate-changelogs. WARNING: Manual edits to this files will be overwritten.
aliases:
- /changes/tenant-cluster-releases-aws/releases/aws-v9.3.6/
changes_categories:
- Workload cluster releases for AWS
changes_entry:
  repository: giantswarm/releases
  url: https://github.com/giantswarm/releases/tree/master/aws/archived/v9.3.6
  version: 9.3.6
  version_tag: v9.3.6
date: '2020-07-31T15:00:00+00:00'
description: Release notes for AWS workload cluster release v9.3.6, published on 31
  July 2020, 15:00.
title: Workload cluster release v9.3.6 for AWS
---

This release updates managed apps to the latest releases, updates Calico to version `3.13.4`, and Flatcar Container Linux to `2512.2.1`.

Below, you can find more details on components that were changed with this release.

### aws-operator [5.7.3](https://github.com/giantswarm/aws-operator/releases/tag/v5.7.3)

- Changes required to run Container linux `2512.2.1` and calico `3.13.4`.

### calico [3.14.3](https://docs.projectcalico.org/archive/v3.13/release-notes/)

- Fix IPAM garbage collection in etcd mode on clusters where node name does not match Kubernetes node name. kube-controllers.

### cluster-operator [0.23.14](https://github.com/giantswarm/cluster-operator/releases/tag/v0.23.14)

- Make NGINX optional on KVM, by ignoring existing NGINX IC App CRs which were managed by cluster-operator.
- Enable NGINX App managed NodePort Service on KVM.

### Container Linux [2512.2.1](https://www.flatcar-linux.org/releases/#release-2512.2.1)

- Fix the Intel Microcode vulnerabilities (CVE-2020-0543)
- Updated Linux kernel to 4.19.128
- Updated intel-microcode to 20200609.

### kube-state-metrics v1.9.7 ([Giant Swarm app v1.1.1](https://github.com/giantswarm/kube-state-metrics-app/blob/master/CHANGELOG.md#111---2020-07-22))

- Updated kube-state-metrics version from 1.9.5 to 1.9.7. Check the [upstream changelog](https://github.com/kubernetes/kube-state-metrics/blob/master/CHANGELOG.md#v197--2020-05-24) for details on all changes.

### metrics-server v0.3.6 ([Giant Swarm app v1.1.1](https://github.com/giantswarm/metrics-server-app/blob/master/CHANGELOG.md#111---2020-07-23))

- Updated metrics-server version from 0.3.3 to 0.3.6. Check the [upstream changelog](https://github.com/kubernetes-sigs/metrics-server/releases) for details on all changes.

### nginx-ingress-controller v0.34.1 ([Giant Swarm app v1.8.3](https://github.com/giantswarm/nginx-ingress-controller-app/blob/master/CHANGELOG.md#183---2020-07-31))

- Drop support for deprecated configuration properties.

### node-exporter v1.0.1 ([Giant Swarm app v1.3.0](https://github.com/giantswarm/node-exporter-app/blob/master/CHANGELOG.md#130---2020-07-23))

- Updated node-exporter version from 0.18.1 to 1.0.1. Check the [upstream changelog](https://github.com/prometheus/node_exporter/blob/master/CHANGELOG.md#101--2020-06-15) for details on all changes.
