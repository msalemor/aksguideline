# AKS Guide

A guide to best practices for Docker, AKS, and other Azure Services

## Docker

### Security

- Update the base images regularly
- Don't run all processes as root
- Use container registry services to scan for vulnerabilities
  - Acqua or Twistlock

## AKS

### Control Plane, Nodes, Pods and Objects

- Control Plane, it is a managed services in Azure
  - Can be deployed as public or private
- Nodes are represented by nodepools of Azure VMs in a ScaleSet
- Diagram: https://phoenixnap.com/kb/understanding-kubernetes-architecture-diagrams
- Pods is the smallest unit of compute deployment in Kubernetes
  - One pod can host many containers 
  - Containers can communicate via localhost (side-car pattern)
- Kubernetes objects are persistent entities in the Kubernetes system. Kubernetes uses these entities to represent the state of your cluster.
  - pods, deployments, services, namespaces
  
### Provisioning and deployment

- Provision the cluster with the Azure CLI as it provides more configuration options
- Enable autoscaling of nodes
- Deploy dev/test and prod to different clusters
- Leverage namespaces to deploy to different environments
  - Link them to groups in AD. This will prevent users from managing (adding, removing, etc.) workloads to different namespaces, but still does not prevent communication between services in the cluster.

### Scalability and bursting

- Enable node and POD scalability
  - https://docs.microsoft.com/en-us/azure/aks/concepts-scale
- You may use Azure Container Instances for bursting
  - https://docs.microsoft.com/en-us/azure/aks/concepts-scale#burst-to-azure-container-instances


### Networking

- Flat model. All pods can communicate with all pods on the cluster regardless of the namespace via FQDN.
- More details: https://kubernetes.io/docs/concepts/cluster-administration/networking/
- There are two networking options, kubenet and CNI
  - Kubenet does not provide inboud communication into the nodes and can work on top of an exsiting network
  - CNI: Recommended. Requires more network planning and IP allocation, and provides ability for inboud communication into the nodes
  - More info: https://docs.microsoft.com/en-us/azure/aks/configure-azure-cni
- Use NGS to restrict communication from outside the cluster, use network policies to restrict communication inside the cluster
  - Note: namespaces do not provide service isolation
- Deployments Types:
  - ClusterIP: LoadBalancer within the cluster
  - LoadBalancer (internal/external): Load Balancer outside the cluster
  - NodePort: Not recommended

### Security

- Patch the nodes
  - Kured: used for nodes requiring reboot 
- Azure AD integration
  - https://docs.microsoft.com/en-us/azure/aks/azure-ad-integration

### Resource Limits

- Set resource limits on PODs
  - k8s will deprevision PODs without resource limits first
  - This is required for auto scaling

### Monitor

- Azure Monitor for containers
  - https://docs.microsoft.com/en-us/azure/azure-monitor/insights/container-insights-analyze
  - Logging to STDOUT
- Application Insights

### Other

- Watch-out for Issues with Upstream features 

### Resources

- http://aksworkshop.io/

## Other Azure Services

### Application Gateway as Ingress Controller

- https://github.com/Azure/application-gateway-kubernetes-ingress

### Azure Container Registry

- Use it to store and retrieve the docker images
  - The premium sku:
    - Provides ability to have global replication of the images and thus images can be used on AKS cluster on different regions
    - Lock down ACR to VNet to the cluster that will consume it
    - Sign the images, and only signed images can be used on the cluster

### Azure Key Vault

- Use it to store and retrieve secrets
  - 12 Factor inject secrets as environment variables
  - Get secrets at runtime (more secure)

### Demos

- https://docs.microsoft.com/en-us/azure/aks/cluster-container-registry-integration
- https://docs.microsoft.com/en-us/azure/aks/use-network-policies
- https://github.com/dapr/samples/tree/master/2.hello-kubernetes

## Microservices architecture

### API Management pattern

- https://docs.microsoft.com/en-us/dotnet/architecture/microservices/ (Page 42)

### Async vs Sync patterns

- https://docs.microsoft.com/en-us/dotnet/architecture/microservices/ (Page 53)

### Resiliency

- Implement Liveness and Readiness probes
- Enable Cluster and App Monitoring
- Transient Fault Handling (retries with exponential backoff and resilient HTTP requests)
- https://docs.microsoft.com/en-us/dotnet/architecture/microservices/ (Page 280)

### 12 Factor

- https://www.ben-morris.com/building-twelve-factor-apps-with-net-core/
- https://12factor.net/

### Resources

- https://docs.microsoft.com/en-us/dotnet/architecture/microservices/
