---
linkTitle: Cluster API Architecture
title: Cluster API Architecture
description: Architecture overview explaining how our platform is built and what services we offer with Cluster API.
weight: 30
menu:
  main:
    parent: cluster-management-cluster-api
last_review_date: 2022-12-07
user_questions:
  - How do you run a developer platform based on Cluster API?
  - How has Giant Swarm built a platform to build platforms with Cluster API?
owner:
  - https://github.com/orgs/giantswarm/teams/team-rocket
  - https://github.com/orgs/giantswarm/teams/team-phoenix
---

The Giant Swarm platform consists of various systems. They can be categorized into three areas: infrastructure, applications, and operations.

For managing the infrastructure we run a management cluster per provider and region wherever you want to have your workloads. From that management cluster you can spin up as many individual Kubernetes clusters, called workload clusters, as you want. Our operations team works to maintain all cluster components' health, while we release new versions with new features and patches. On top of that, Giant Swarm offers a curated catalog with the most common Cloud Native tools that helps to monitor, secure or manage your applications. Customers can leverage those while we carry the burden of maintaining, securing and keeping them up to date.

Giant Swarm's architecture is split into two logical parts. One encompasses the management cluster and all the components running there. The second part  refers to the workload clusters that are created dynamically by the users to run their business workloads. In principle the management cluster and workload cluster(s) are analogous in terms of infrastructure and configuration. The difference comes with the additional layers we deployed on top of the management cluster that helps manage your users and permissions, workload clusters or the applications running on the workload clusters.

## Cluster Architecture

As explained previously, both the management cluster and the workload cluster(s) have the same structure and configuration. In Giant Swarm we rely on [Cluster API](https://cluster-api.sigs.k8s.io/) to bootstrap and configure the cluster infrastructure and set up all the components needed for a cluster to function.

![Cluster architecture image](CAPI_architecture.png)

By default, the machines are split into three different failure domains or zones to ensure the availability of the API and workloads running. In our setup, three control plane machines hold the Kubernetes API and the other controllers, and a variable number of worker machines contain the regular services.

There is a machine created as a bastion that helps us with the operations. It is the single entry point to the running infrastructure. This way all the cluster machines can live in a private network and expose the services running on them via explicit configuration.

{{< tabs >}}
{{< tab id="cluster-capo" for-impl="capo" >}}

The setup requires an external network configured in the project to allow the machines to pull images or route requests from containers to the Internet. On the other side, there is an internal network which interconnects all master and worker machines allowing the internal communication of all containers within the cluster. At the same time, it allocates the load balancers that are created dynamically as result of exposing a service in the cluster. In case the load balancer is external, a floating IP is allocated to enable the connection with external endpoints.

{{< /tab >}}
{{< tab id="cluster-capv" for-impl="capv" >}}

### Compatibility

The setup supports vSphere 6.7 Update 3 and above to have the Cloud Native Storage (CNS) feature. 

### Authentication

Cluster API Provider vSphere (CAPV), along with the associated Cloud Provider interface (CPI) and Container Storage interface (CSI), authenticate against the VMware vSphere API using credentials stored in a secret. 

### Networking

vSphere has no concept of load balancer so we leverage [`kube-vip`](https://kube-vip.io/) to provide load balancing in ARP mode (layer-2) for the kubernetes API, as well as the `kube-vip` cloud provider (CPI) for services with `type: LoadBalancer`.

By default kube-vip requires to set IP addresses manually. To solve this, we install [cluster-api-ipam-provider-in-cluster](https://github.com/giantswarm/cluster-api-ipam-provider-in-cluster-app) in the clusters to control IP allocation through the use of `IPAddressClaims`. This has the benefit of being compatible with any vSphere environment, regardless of the network architecture, and avoid IP duplicates. This means that we recommend reserving a layer 2 subnet per management cluster.

### Failure Domains

Virtual machines created on the infrastructure to run the Kubernetes nodes can be provisioned in different ways to account for different failure domains. CAPV supports spreading VMs on different nodes within the same cluster, different clusters within the same datacenter and on different datacenters within the same vCenter.

### Storage

In order to offer persistent storage that is decoupled from the virtual machines, the container storage interface creates a Container Volume in vSphere that can be attached or detached from the VM according to whether or not the persistent volume claim (PVC) is bound to a pod or not. Container Volumes support Read-Write-Only (RWO) and Read-Write-Many (RWX) if VSAN File Services is enabled.

{{< /tab >}}
{{< tab id="cluster-capvcd" for-impl="capvcd" >}}

### Compatibility

The setup supports organisation virtual datacenters (OVCDs) running on VMware Cloud Director 10.3 and above. It must be backed by backed with NSX-T and NSX advanced load balancer (ALB) with the load balancer feature enabled on the Edge gateway. 

### Authentication

Cluster API Provider VMware Cloud Director (CAPVCD), along with the associated Cloud Provider interface (CPI) and Container Storage interface (CSI), authenticate against the VMware Cloud Director API using an API Token (sometimes also referred to as Refresh Token) which is stored in a secret. Such token can be created by any user with the right permission and can be revoked at any time should there be suspicion of it being compromised.

### Networking

The kubernetes API and services of type `LoadBalancer` get IPs from a pool of external IPs available in the edge gateway. It can be set statically or takes the next available IP if unspecified. A virtual service is then created with the required IP/port and is associated with a load balancer pool that contains the relevant node IPs as members. For the CPI, we support the virtual service shared feature which was introduced in VCD 10.4 as well as the legacy method based on a single internal IP and multiple DNAT rules.

A network needs to be specified in the cluster definition to identify where the default gateway will be and where to connect the virtual machines (VMs). It is also possible to add additional networks in order to connect multiple virtual interfaces to the nodes along with a list of static routes. The nodes must have internet access which is usually achieved with a SNAT rule or via an HTTP proxy. Note that it is also possible to specify NTP servers and pools (Ubuntu based nodes running `chrony`) in the cluster definition, which is particularly useful in air-gapped environments.

### Compute

The Kubernetes cluster is represented in VMware Cloud Directior by a vAPP of the same name that contains one virtual machine for each node. Note that our setup also supports naming conventions for virtual machine names based on go templates. When a node is created, a virtual machine is provisioned in the cluster's vAPP using a vAPP template stored in a specific catalog. When configuring the control plane nodes or a node class for a node pool, several parameters can be set for the virtual machines such as the sizing policy, placement policy, virtual disk size and storage profile.

### Storage

In order to offer persistent storage that is decoupled from the virtual machines, the container storage interface creates a Named Disk that can be attached or detached from the VM according to whether or not the persistent volume claim (PVC) is bound to a pod or not. Named disks currently only support Read-Write-Only (RWO) with block storage backed named disks.

{{< /tab >}}
{{< tab id="cluster-capa_ec2" for-impl="capa_ec2" >}}

The setup uses a standalone VPC (though you can bring your own VPC) and creates private subnets for the machine in each availability zone. It uses NAT gateways for allowing machines to pull images or route requests from containers to the Internet. On the other side, it needs an Internet Gateway to route traffic from Internet to the containers. It leverages route tables to configure the routing for each subnet and gateways.

{{< /tab >}}
{{< tab id="cluster-capz_vms" for-impl="capz_vms" >}}

{{< /tab >}}
{{< tab id="cluster-capg_vms" for-impl="capg_vms" >}}

The setup uses the default network if none has been created upfront for the purpose. Every Google project always come with a default network. The network allows the machines to pull images or route requests from containers to the Internet. The machines are running in private subnets configured to use a Cloud NAT gateway to access the outside network. At the same time, Google uses Global Load Balancer to route external requests to the containers.

{{< /tab >}}
{{< /tabs >}}

Internally, Cluster API (CAPI) uses kubeadm to configure all the machines according to current standards. It uses a template defined as yaml, part of CAPI, where we have hardened the different parameters for the API and other controllers running in the master machine.

## Giant Swarm Platform

The Giant Swarm platform is based on the API of the management cluster. The main reason is that Kubernetes has become the de-facto standard for managing infrastructure in a modern way. Its extensibility makes it easy to transform a cluster in a platform with a secret sauce that makes the experience great.

Our platform lets customers manage (workload) clusters and applications in a Cloud Native fashion. Following is an explanation of the bootstrapping process of a cluster, how it is managed throughout its lifecycle and which cluster components run based on its role (i.e. workload cluster or management cluster).

### Components

There are two types of components: generic and self-developed.

#### Generic Components

The generic components run in all of our clusters regardless of whether it is a management cluster or a workload cluster.

##### Container Network Interface (CNI)

The Container Network Interface is the standard for writing plugins to configure network interfaces in Linux containers, and hence Kubernetes.

We have chosen Cilium as the CNI implementation for several reasons. It is an open source solution that provides connectivity between containers in reliable and secure way. Cilium operates at Layer 3/4 providing traditional networking and security services. Additionally it protects and secures applications offering different enhanced features on top. For now, it is used only as container network in workload clusters.

##### Kube State Metrics

Kube State Metrics (KSM) is an upstream project that watches the Kubernetes API and provides metrics about the state of built-in resources. It is used by our monitoring service to scrape the metrics of the core components so we can be paged when something is wrong with the cluster. At the same time customers can scrape these metrics to create their own dashboards and alerts.

##### Cert exporter

It is a Prometheus exporter that exposes a set of metrics regarding certificates and tokens. It enables us to stay ahead of certificates expiration and take care of them in a timely fashion.

##### Net exporter

Net exporter is also a Prometheus exporter for exposing network information. It runs on every node to track network and DNS errors. We created dashboards to help us debug issues on the cluster. In addition some of our alerts are based on the metrics exported by it.

##### Metrics server

Metrics Server is an upstream component that implements the [Kubernetes Metrics API](https://kubernetes.io/docs/tasks/debug/debug-cluster/resource-metrics-pipeline/#metrics-api) to provide basic data of the container running in the cluster. It gives us information about CPU and memory usage of every pod. It is also used by other components, like Horizontal Pod Autoscaler, for scaling decisions. 

##### Node exporter

It is an upstream Prometheus exporter for tracking hardware and operating system metrics exposed by *NIX kernels. It completes our monitoring service giving us the possibility to track resources used in the nodes and let us create alerts based on that information.

#### Giant Swarm Components

In addition to generic components, we deploy a set of controllers and extensions to the management API. The purpose of which is to enhance the user experience of managing clusters and apps on top of Kubernetes.

There are three types of Giant Swarm components running on the management clusters: the operators, the admission controllers and the operational services. The first one, operators, extend the API allowing our customers to manage new entities (like a Cluster or an App) as if they were built-in resources. The second one, admission controllers, validate and default the resources to create a better user experience. And the last one, the operational services, monitoring or security, enable our staff to ensure all the workload clusters and applications are up and running securely and seamlessly.

##### Operators (Custom Resource plus controller)

The most common pattern to extend Kubernetes is called [Operator](https://kubernetes.io/docs/concepts/extend-kubernetes/operator/). It allows to define a new [Kubernetes resource](https://kubernetes.io/docs/concepts/extend-kubernetes/api-extension/custom-resources/) (called Custom Resource) and apply functionality to it. 

In Giant Swarm we leverage the operator pattern to extend the management cluster and provide a great user experience to our customers.

*Organization operator*

This operator is in charge of reconciling `Organization` custom resources. The functionality of the operator is pretty straightforward. It creates and deletes the organization namespace when the given resource is created.

To learn more about organizations please read [the related documentation]({{< relref "/platform-overview/multi-tenancy" >}}).

*RBAC operator*

We have built an RBAC operator with the goal of maintaining up to date permissions between the different organizations and users on the management cluster so [you can isolate your teams and ensure access level in a granular way]({{< relref "/use-the-api/management-api/authorization" >}}).

*DNS operator*

We built an operator to manage the DNS entries for all the endpoints we need to expose to our customers. All our management clusters have a base domain used to allocate the API, OIDC endpoint or UI. This operator listens to cluster resource and provides the right records.

*Deletion Blocker Operator*

Kubernetes ensures resources are deleted in the right order by using `finalizers`, a way to create dependencies between resources. In specific cases, some CRs don't leverage finalizers, which can stop the deletion process when they are deleted too early and leave the cluster in an inconsistent state. Deletion Blocker Operator ensure that specific CRs aren't deleted until specific conditions are met.

*App operator*

The [App Platform]({{< relref "/platform-overview/app-platform" >}}) is a system we built to deliver Cloud Native Apps in a multi cluster fashion. App operator is the main code running in management clusters to manage App custom resources and make sure the applications and configuration are delivered correctly across the different workload clusters.

*Cluster API operators*

In [Cluster API](https://cluster-api.sigs.k8s.io/) there is a set of generic operators that all Cluster API providers run to address the common bootstrap and management actions on a Kubernetes cluster lifecycle which include:

- `Kubeadm Bootstrap` controller which is in charge of providing a cloud init configuration to turn a machine into a Kubernetes node.
- `Kubeadm Control Plane` controller that manages the lifecycle of the control plane nodes and provides access to the API.
- `CAPI manager` controller that manages cluster and machine resources.

*Cluster Provider operator*

In Cluster API there is a set of common providers defined above, but to manage the real infrastructure we need to run a specific controller that knows about the cloud provider's API. It acts as a bridge and reconciles the provider specific configuration to create the necessary infrastructure for a Kubernetes cluster (i.e. VMs, Load Balancers...). This controller provisions, updates and deletes all resources through API. Every provider has its own lingo and methods to create a machine or provision a network. The operator reconciles the infrastructure resources of the specific provider parsing the desired state into API requests and ensuring the provider resources are always in sync with the resource definitions stored in the management cluster.

*Cluster Apps operator*

This simple operator takes care of providing the basic configuration for our Managed Apps. Assets like the certificate authority or the domain base are provided by it via a Config Map so the different apps can rely on those values to configure themselves.

##### Admission controllers

The [Admission Controller](https://kubernetes.io/docs/reference/access-authn-authz/admission-controllers/) is another feature Kubernetes offers to extend its functionality. This time the idea is to intercept the API requests for validating or mutating the content. The main reason is to block users from submitting wrong data or  to default some of the properties for custom resources. 

*App Admission Controller*

This admission controller gives the ability to our App Platform to ensure an App is created properly, with all required files and points to an existing App in the Catalog. At the same time, it allows our customers to pass the bare minimum required spec and will default the rest automatically.

*Cluster API admission controllers*

Each CAPI controller has its own admission to enhance the cluster management experience. Basically it performs same actions of validation and mutation. 

*Management admission controller*

As we described before, organizations are used to organize clusters and apps, but we need an admission  controller to make sure some rules are respected. For example, you cannot delete an organization if it has cluster running on it. This controller ensures the request respects those rules.

*Kyverno admission controller*

[Pod Security Policies are deprecated](https://kubernetes.io/blog/2021/04/06/podsecuritypolicy-deprecation-past-present-and-future/) and from Kubernetes `1.25` they will not be valid anymore. In the past we relied on this functionality to harden the cluster and ensure containers run with the least privileges required. As a replacement we implemented equivalent policies in [Kyverno](https://kyverno.io/). 

##### Operational services

Aside from operators and admission controllers we also deploy a set of tooling that ensure we have a nice delivery system, good hardening and clear observability.  

*Authentication Features of the Platform*

Giant Swarm configures the clusters in a secure way. [Role-Based Access Control (RBAC)](https://kubernetes.io/docs/reference/access-authn-authz/rbac/) is enabled by default and our customers can create their own roles or use the ones predefined in the cluster to gain access to manage their workloads. The concept of authenticated users and groups does not exist in Kubernetes, so it relies on an external solution to retrieve user/group information (e.g. via X.509 certificates or [OIDC](https://en.wikipedia.org/wiki/OpenID_Connect)). Although our platform allows users to access their clusters using certificates, we recommend using an OIDC compliant Identity Provider, such as Active Directory, to provide authentication. There are several advantages to using an OIDC provider, such as short lived tokens or taking advantage of existing user and group information. Once authentication is sorted out, the authorization part is handled with RBAC. RBAC, along with namespaces, lets users define granular permissions for each user or group. This [guide]({{< relref "/getting-started/rbac-and-psp" >}}) will walk you through it.

*Secure Features of the Platform*

From our first versions, Giant Swarm has set up a secure baseline in all our customer clusters. In the early days, Kubernetes released [Pod Security Policies (PSPs)](https://kubernetes.io/docs/concepts/policy/pod-security-policy/) to enforce pod security providing a new built-in resource where user can define the user group permissions or volume types allowed. In Kubernetes `1.25` this implementation is phased out instead of [Pod Security Admission(PSA)](https://kubernetes.io/docs/concepts/security/pod-security-admission/). We have not found an equivalent set of policies using that technology so for now we have decided to leverage on Kyverno to enforce our same restricted policies](https://www.giantswarm.io/blog/giant-swarms-farewell-to-psp). By default, users and workloads running in Giant Swarm clusters, are assigned a restrictive policy that disallows running containers as root or mounting host path volumes (these are just two examples). Cluster operators must enable applications to have higher security privileges on a case by case basis. 

In addition to the security policies, [Network Policies](https://kubernetes.io/docs/concepts/services-networking/network-policies/) define the communication policies to and from the applications in each namespace. All components to run a cluster provided by Giant Swarm come with strict policies by default. Our managed namespaces (“kube-system” and “giantswarm”) block all traffic in general, so only expected and specifically configured routes and ports are enabled. Customers can follow this approach and deny all communications by default in their application namespaces forcing each workload to define which communications are allowed. This [guide]({{< relref "/getting-started/network-policies" >}}) helps to understand how such a dynamic firewall works.

*Monitoring Features of the Platform*

Since we provide a **managed** Kubernetes platform, Giant Swarm has to be aware of state and unexpected events regarding the platform. For that reason our management clusters run a [monitoring stack](https://www.giantswarm.io/blog/monitoring-on-demand-kubernetes-clusters-with-prometheus) to watch all workload clusters and ensure all managed components are healthy. In each workload cluster there are several [exporters](https://prometheus.io/docs/instrumenting/exporters/) that gather and forward the metrics for each component.

Our on-call engineers are paged in case anything happens to the cluster or its base components. They respond to the incident based on our run-books, the ones we have written (and continue to update) over years operating Cloud Native systems. In case there is an improvement to be made, a post mortem is created and a solution will be implemented before long. Any patch or fix added to the platform is released to all customers.

*CI/CD Features of the Platform*

Since the appearance of [GitOps](https://www.giantswarm.io/blog/what-is-gitops) we have been enthusiastic about it. It provides many benefits while relying on the same principles we were already advocating for. In Giant Swarm, we use [Flux](https://www.giantswarm.io/blog/gitops-with-flux-giant-swarm) to control the configuration and definition of infrastructure and the software on top of it.

In our setup we have two Flux instances running, one managing the resources specific to the overall operation of the management cluster (`flux-giantswarm`) and the second for handling resources generated by the customer (`flux-system`).

To support customers in their use of Flux and the CI/CD features available to the platform, we provide a common template structure [gitops-template](https://github.com/giantswarm/gitops-template/) which presents structures, ideas and best practices on how to use flux within the Giant Swarm eco-system.

### Bootstrapping

The initial deployment entails the creation of that management cluster in a defined region. We built a tool that performs all steps needed to create a cluster and convert it to a management cluster.

The process involves several steps that we will review briefly in the following list:

1. Configure the credentials for the chosen provider.
2. Add the installation details into our config management system (Github repo).
3. Create a bootstrap cluster using [kind](https://kind.sigs.k8s.io/).
4. Install the Cluster API (CAPI) controllers on it.
5. Create the management CAPI resources on the bootstrapping cluster to trigger the provision of the real infrastructure on the provider. It creates the actual Kubernetes cluster in the customer infrastructure.
6. Install the Cluster API controllers on the real management cluster and move the resources to it.
7. Deploy our App platform on top of the management cluster.
8. Deploy our monitoring system on top of the management cluster.
9. Deploy all additional operators that enhances the API (organizations, RBAC, etc).
10. Configure and harden the cluster.
11. Run and test the management cluster functionality.

After the management cluster is ready we deliver all the details to customers to give them the access to the Management API. From this point we use the same mechanisms to control the management cluster lifecycle as we use for workload clusters.

Cluster API offers a set of custom resources that define all the details of a cluster infrastructure and its configuration. 

![Cluster API resources](CAPI_resources.png)

Usually we have generic resources that define common configuration of the clusters and its components, and some infrastructure specific resources which will be tied to the provider we select. 

We have created a [kubectl plugin]({{< relref "/use-the-api/kubectl-gs/template-cluster" >}}) to help you template all the needed resources.

## Further Reading

- [Giant Swarm support model]({{< relref "/support" >}})
- [Giant Swarm operational layers]({{< relref "/platform-overview/security/operational-layers" >}})
- [Giant Swarm VPN and secure cluster access]({{< relref "/platform-overview/security/cluster-security/cluster-access" >}})

