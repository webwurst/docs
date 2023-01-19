---
linkTitle: Creating a base template for workload clusters
title: Creating a base template for workload clusters
description: How to create a base template to create workload clusters with different configurations.
weight: 70
menu:
  main:
    parent: advanced-gitops
    identifier: advanced-gitops-bases
user_questions:
  - How can I create an base template for workload clusters in GitOps?
owner:
  - https://github.com/orgs/giantswarm/teams/team-honeybadger
last_review_date: 2023-01-20
---

# Add a CAPx (CAPI) Workload Cluster template (cluster App based)

Our CAPx (CAPI provider-specific clusters) are delivered by Giant Swarm as a set of two applications. First one
is an App with Cluster instance definition, second one is an App with all the default applications a new cluster
needs in order to run correctly. As such, creating a CAPx cluster means that you need to deliver two correctly
configured App CRs to the Management Cluster.

Adding definitions can be done on two levels: shared cluster template and version specific template, see
[create shared template base](#create-shared-template-base)
and [create versioned base](#create-versioned-base-optional).


**IMPORTANT**, CAPx configuration utilizes the
[App Platform Configuration Levels](/getting-started/app-catalog/app-configuration/#levels),
in the following manner:

- cluster templates provide default configuration via App' `config` field,
- cluster instances provide custom configuration via App' `userConfig` field, that is overlaid on top of `config`.

See more about this approach [here](https://github.com/giantswarm/rfc/tree/main/merging-configmaps-gitops).



## Export environment variables

**Note**, Management Cluster codename, Organization name and Workload Cluster name are needed in multiple places
across this instruction, the least error prone way of providing them is by exporting as environment variables:

```sh
export MC_NAME=CODENAME
export ORG_NAME=ORGANIZATION
export WC_NAME=CLUSTER_NAME
```

## Choose bases

In order to avoid code duplication, it is advised to utilize the
[bases and overlays](https://kubernetes.io/docs/tasks/manage-kubernetes-objects/kustomization/#bases-and-overlays)
of Kustomize in order to configure the cluster.

## Create shared cluster template base {#create-shared-template-base}

**IMPORTANT:** shared cluster template base should not serve as a standalone base for cluster creation, it is there only to abstract
App CRs that are common to all clusters versions, and to provide basic configuration for default apps App.
It is then used as a base to other bases, which provide an overlay with a specific configuration. This is to avoid
code duplication across bases.

**Bear in mind**, this is not a complete guide of how to create a perfect base, but rather a mere summary of basic
steps needed to move forward. Hence, instructions here will not always be precise in telling you what to change,
as this can strongly depend on resources involved, how much of them you would like to include into a base, etc.

We provide a command to create bases for CAPI clusters in an easy way. A base can be created by running:

```sh
kubectl gs gitops add base --provider capa
```

The current possible values for the providers can be checked in the [command reference](/use-the-api/kubectl-gs/gitops/add-base)

## Create versioned base (optional) {#create-versioned-base-optional}

**IMPORTANT**, versioned cluster template bases use a shared cluster template base and overlay it with a preferably
generic configuration for a given cluster version. Versioning comes from the fact that `values.yaml` schema may change
over multiple releases,
and although minor differences can be handled on the `userConfig` level, it is advised for the bases to follow major
`values.yaml` schema versions to avoid confusion.

In the `gitops-template` repository there is an example for CAPO [v0.6.0](https://github.com/giantswarm/gitops-template/tree/main/bases/clusters/capo/>=v0.6.0) as major changes were introduced
to the `values.yaml` in the [cluster-openstack v0.6.0 release](https://github.com/giantswarm/cluster-openstack/releases/tag/v0.6.0).

**IMPORTANT**, despite the below instructions referencing `kubectl-gs` for templating configuration, `kubectl-gs`
generates configuration for the most recent schema only. If you configure a base for older versions of cluster app,
it is advised to check what is generated against the version-specific `values.yaml`.

1. Export CAPx name, provider name and cluster App version you are about to create, for example `capo`, `openstack` and `v0.8.0`:

    ```sh
    export CAPX=capo
    export PROVIDER=openstack
    export CLUSTER_VERSION=v0.8.0
    export DEFAULT_APPS_VERSION=v0.2.0
    ```

1. Create a directory structure:

    ```sh
    mkdir -p bases/clusters/${CAPX}/${VERSION}
    mkdir -p bases/nodepools/${CAPX}/${VERSION}
    ```

1. Use the [kubectl gs template cluster](use-the-api/kubectl-gs/template-cluster/) to template
cluster resources, see example for the `openstack` provider below. Use arbitrary values for the mandatory fields, we
will configure them later in our process:

    ```sh
    kubectl gs template cluster \
    --bastion-image aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa \
    --bastion-machine-flavor=n1.tiny \
    --cloud openstack \
    --cloud-config cloud-config \
    --cluster-catalog giantswarm \
    --control-plane-image cccccccc-cccc-cccc-cccc-cccccccccccc \
    --control-plane-machine-flavor n1.small \
    --default-apps-catalog giantswarm \
    --external-network-id bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb \
    --name mywcl \
    --node-cidr 10.6.0.0/24 \
    --organization myorg \
    --provider openstack \
    --worker-failure-domain gb-lon-1 \
    --worker-image cccccccc-cccc-cccc-cccc-cccccccccccc \
    --worker-machine-flavor n1.small \
    --worker-replicas 3 > bases/clusters/${CAPX}/${VERSION}/cluster.tmp.yaml
    ```

1. Split up the `cluster.yaml` into multiple files:

    ```sh
    COUNT=$(grep -e '---' bases/clusters/${CAPX}/${VERSION}/cluster.tmp.yaml | wc -l | tr -d ' ')
    csplit bases/clusters/${CAPX}/${VERSION}/cluster.tmp.yaml /---/ "{$((COUNT-2))}"
    rm bases/clusters/${CAPX}/${VERSION}/cluster.tmp.yaml
    ```

1. Discard everything except `mywcl-cluster-userconfig` and move it to the base:

    ```sh
    for f in $(ls xx*)
    do
        name=$(yq eval '.metadata.name' $f | tr '[:upper:]' '[:lower:]')
        if [[ "$name" == "mywcl-cluster-userconfig" ]]
        then
            yq eval '.data.values' $f > bases/clusters/${CAPX}/${VERSION}/cluster_config.yaml
        else
            rm $f
        fi
    done
    ```

1. Replace `mywcl`, `myorg` values from the previous step with variables:

    ```sh
    sed -i "s/myorg/${organization}/g" bases/clusters/${CAPX}/${VERSION}/cluster_config.yaml
    sed -i "s/mywcl/${cluster_name}/g" bases/clusters/${CAPX}/${VERSION}/cluster_config.yaml
    ```

1. Compare `cluster_config.yaml` against the version-specific `values.yaml`, and tweak it if necessary to match the
expected schema. At this point you may also provide extra configuration, like additional availability zones, node
pools, etc.:

    ```sh
    wget https://github.com/giantswarm/cluster-openstack/archive/refs/tags/${CLUSTER_VERSION}.tar.gz
    tar -xvf ${CLUSTER_VERSION}.tar.gz cluster-${PROVIDER}-${CLUSTER_VERSION:1}/helm/cluster-${PROVIDER}/values.yaml
    vim cluster-openstack-${CLUSTER_VERSION:1}/helm/cluster-${PROVIDER}/values.yaml
    ```

1. Create a patch for the cluster App CR to provide the newly created configuration:

    ```sh
    cat <<EOF > bases/clusters/${CAPX}/${VERSION}/patch_config.yaml
    apiVersion: application.giantswarm.io/v1alpha1
    kind: App
    metadata:
      name: \${cluster_name}
      namespace: org-\${organization}
    spec:
      extraConfigs:
        - kind: configMap
          name: \${cluster_name}-config
          namespace: org-\${organization}
          priority: 1
    EOF
    ```

1. Create the `kustomization.yaml`, referencing the template, and generating the ConfigMap out of `cluster_config.yaml`:

    ```sh
    cat <<EOF > bases/clusters/${CAPX}/${VERSION}/kustomization.yaml
    apiVersion: kustomize.config.k8s.io/v1beta1
    configMapGenerator:
      - files:
        - values=cluster_config.yaml
        name: \${cluster_name}-config
        namespace: org-\${organization}
    generatorOptions:
      disableNameSuffixHash: true
    kind: Kustomization
    patchesStrategicMerge:
      - patch_config.yaml
    resources:
      - ../template
    EOF
    ```

1. Copy `readme.md` from the template base:

    ```sh
    cp bases/clusters/${CAPX}/template/readme.md bases/clusters/${CAPX}/${VERSION}/readme.md
    ```

1. Export bases paths:

    ```sh
    export CLUSTER_PATH=bases/clusters/${CAPX}/${VERSION}
    ```

