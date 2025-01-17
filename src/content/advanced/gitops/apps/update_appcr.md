---
linkTitle: Update an existing App
title: Update an existing App
description: Learn how to update an App already deployed in a workload cluster with GitOps.
weight: 50
menu:
  main:
    identifier: advanced-gitops-apps-app-update
    parent: advanced-gitops-apps
last_review_date: 2023-02-10
user_questions:
  - How can I update an existent app deployed with GitOps?
owner:
  - https://github.com/orgs/giantswarm/teams/team-honeybadger
---

This document is part of the documentation to use GitOps with Giant Swarm App Platform. You can find more information about the [App Platform in our docs](/platform-overview/app-platform/).

# Update an existing App

Follow the below instructions to update an existing App.

## Export environment variables

The Management Cluster codename, Organization name, Workload Cluster name and App name are needed in multiple places across this instruction, the least error prone way of providing them is by exporting them as environment variables:

```sh
export MC_NAME=CODENAME
export ORG_NAME=ORGANIZATION
export WC_NAME=CLUSTER_NAME
export APP_NAME=APP_NAME

## Updating App

  App update and reconfiguration must be done in the correct resource. If you want to reconfigure a property of App CR, like the application version, you have to edit the `appcr.yaml` file. If you want to edit the plain text or encrypted configuration, you have to edit the relevant resource type.

### Updating App CR

1. Go to the App directory:

    ```sh
    cd management-clusters/${MC_NAME}/organizations/${ORG_NAME}/workload-clusters/${WC_NAME}/mapi/apps/${APP_NAME}
    ```

1. Edit the `appcr.yaml` if you want to update the App CR fields, like version, catalog, etc. For all the supported fields reference [the App CRD schema](https://docs.giantswarm.io/ui-api/management-api/crd/apps.application.giantswarm.io/)

### Updating ConfigMap-based user values

1. Go to the App directory:

    ```sh
    cd management-clusters/${MC_NAME}/organizations/${ORG_NAME}/workload-clusters/${WC_NAME}/mapi/apps/${APP_NAME}
    ```

1. Edit the `configmap.yaml` if you want to update a non-secret user configuration

### Updating Secret-based user values

1. Go to the App directory:

    ```sh
    cd management-clusters/${MC_NAME}/organizations/${ORG_NAME}/workload-clusters/${WC_NAME}/mapi/apps/${APP_NAME}
    ```

1. Import the WC's regular GPG private key from your safe storage into your keychain. In our example, we're gonna use `LastPass` for that:

    ```sh
    gpg --import \
    <(lpass show --notes "Shared-Dev Common/GPG private key (${MC_NAME}, ${WC_NAME}, Flux)")
    ```

1. Decrypt the `secret.enc.yaml` file with SOPS:

    ```sh
    sops --decrypt --in-place secret.enc.yaml
    ```

1. Grab the `.data.values` field from the Secret and base64-decode it:

    ```sh
    yq eval .data.values secret.enc.yaml | base64 -d > values.tmp.yaml
    ```

1. Edit the `values.tmp.yaml` if you want to update a secret user configuration

1. Save the base64-encoded `values.tmp.yaml` into variable:

    ```sh
    export NEW_USER_VALUES=$(cat values.tmp.yaml | base64)
    ```

1. Replace Secret's `.data.values` with new value:

    ```sh
    yq -i eval ".data.values = \"${NEW_USER_VALUES}\"" secret.enc.yaml
    ```

1. Remove the `values.tmp.yaml`:

    ```sh
    rm values.tmp.yaml
    ```

1. Re-encrypt the Kubernetes Secret:

    ```sh
    sops --encrypt --in-place secret.enc.yaml
    ```

1. Remove the private GPG key from your keychain and submit the PR.

    ```sh
    gpg --delete-secret-keys "${KEY_FP}"
    ```
