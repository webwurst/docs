---
linkTitle: Tools
title: Cost optimization tools
description: Cost is always a concern when running IT infrastructure. This document is a curated list of cost optimization tools that we have found to be valuable for our customers and ourselves.
weight: 100
menu:
  main:
    parent: cost-optimization
last_review_date: 2023-07-10
user_questions:
- What cost optimization tools do you recommend?
- How can I tune my setup to optimize for cost?
aliases:
owner:
  - https://github.com/orgs/giantswarm/teams/team-horizon
---

The adoption of Kubernetes still requires monitoring cost drivers. Improving resource utilization allows you to get the most out of your infrastructure while maintaining your budget. This document is comprised of a curated list of helpful tools on the journey to cost optimization. The list is based on our experience building and running our own infrastructure, in addition to the learnings we gained from working with large global enterprises.

## Visualization and Optimization

- [Kubecost](https://www.kubecost.com/), an open-source cost visualization tool, with a kubectl [plugin](https://blog.kubecost.com/blog/kubectl-cost-kubernetes-monitoring-cli/) included. Requires a daemon to be running in the cluster.
- [Opencost](https://github.com/opencost/opencost) It is the free version of Kubecost product with limited functionalities over the original.
- Cloud Provider tooling:
    - [AWS Cost Explorer](https://aws.amazon.com/es/aws-cost-management/aws-cost-explorer/)
    - [Azure Cost Management and Billing Service](https://azure.microsoft.com/en-us/services/cost-management/)
- [Kube-capacity](https://github.com/robscott/kube-capacity), a simple kubectl plugin that helps with visualize usage across nodes
- [Prometheus + Grafana + exporters](https://github.com/giantswarm/prometheus-operator-app)
    - [Limit/Requests exporter](https://github.com/cloudworkz/kube-eagle)
    - [AWS CloudWatch data source integration](https://grafana.com/docs/grafana/latest/datasources/cloudwatch/#iam-policies)
    - [Azure Monitor data source integration](https://grafana.com/grafana/plugins/grafana-azure-monitor-datasource/)
- [Goldilocks](https://github.com/FairwindsOps/goldilocks), a tool for refining and discovering the right application resource settings
- There are multiple paid solutions offering dashboard-oriented services to track Kubernetes application costs or help to reduce cloud costs. For example:
    - [Zesty](https://zesty.co/) Real-time controller that measures machine resource usage and adapts Reserved Instances using the AWS Marketplace. 
    - [Cloudability](https://www.apptio.com/products/cloudability/)
    - [Kubernetes Opex Analytics](https://github.com/rchakode/kube-opex-analytics)
    - [CloudHealth](https://www.cloudhealthtech.com/)

## Autoscaling

- [Cluster Autoscaler](https://github.com/kubernetes/autoscaler/tree/master/cluster-autoscaler) scales up, based on unscheduled pods, and down nodes when a certain threshold is reached
- [Karpenter](https://github.com/aws/karpenter). It is more effective in downscaling resources as well as letting more flexibility in adding different provisioners for different necessities within the cluster. Karpenter offers more effective and granular scaling functionalities based on specific workload requirements.
- [Horizontal Pod Autoscaler](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/) scale out/in the replicas of you application based on metrics defined
- [Vertical Pod Autoscaler](https://github.com/giantswarm/vertical-pod-autoscaler-app) evaluate and modify current application resource based on usage
- [Custom Metrics Adapter](https://github.com/zalando-incubator/kube-metrics-adapter) makes it possible to scale your application based on a new different set of metrics

## Dev/Test clusters

- [Janitor](https://codeberg.org/hjacobs/kube-janitor), a tool that leverages on resource annotations to clean and set TTL for your deployments, find out unused volumes,...
- [Kubernetes Downscaler](https://codeberg.org/hjacobs/kube-downscaler) scales down deployments on your non-production cluster based on some conditions
- [Cluster cleaner](https://github.com/giantswarm/cluster-cleaner) automatically removes workload clusters after a defined amount of time. 

## Summary

Cost optimization is a journey. You will find you need to adopt different tools and continually tweak your setup to get the greatest benefit from cloud-native.
