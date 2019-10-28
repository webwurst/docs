+++
title = "gsctl Command Reference: update nodepool"
description = "The 'gsctl update nodepool' command allows renaming of a node pool."
date = "2019-10-28"
type = "page"
weight = 44
+++

# `gsctl show nodepool`

<div class="well disclaimer">
<a href="/basics/nodepools/">Node pools</a> are a new concept to be introduced soon to Giant Swarm customers on AWS.
</div>

The `gsctl update nodepool` allows renaming of a node pool.

## Usage

The command is called with the cluster and node pool ID as a positional argument,
separated by a slash. The `--name` flag is used to set a new name.

Example:

```nohighlight
gsctl update nodepool f01r4/op1dl --name "New node pool name"
```

Here, `f01r4` is the cluster ID and `op1dl` is the node pool ID.

## Related

- [`gsctl create nodepool`](/reference/gsctl/create-nodepool/) - Add a node pool to a cluster
- [`gsctl list nodepools`](/reference/gsctl/list-nodepools/) - List all node pools of a cluster
- [`gsctl update nodepool`](/reference/gsctl/update-nodepool/) - Modify a node pool
- [`gsctl delete nodepool`](/reference/gsctl/delete-nodepool/) - Delete a node pool