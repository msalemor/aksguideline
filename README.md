# Microservices, Docker, AKS, and Other Azure Services

A guide to best practices for Docker, AKS, and other Azure Services

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

- https://12factor.net/

### Resources

- https://docs.microsoft.com/en-us/dotnet/architecture/microservices/


## Docker

### Security

- Update the base images regularly
- Don't run all processes as root
- Use container registry services to scan for vulnerabilities

## AKS

### Provisioning and deploymnet

- Provision the cluster with the Azure CLI as it provides more configuration options
- Enable autoscaling of nodes
- Deploy dev/test and prod to different clusters

### Scalability and bursting

- Enable node and POD scalability
  - https://docs.microsoft.com/en-us/azure/aks/concepts-scale
- You may use Azure Container Instances for bursting
  - https://docs.microsoft.com/en-us/azure/aks/concepts-scale#burst-to-azure-container-instances


### Networking

- There are two networking options, kubenet and CNI
  - Kubenet does not provide inboud communication into the nodes and can work on top of an exsiting network
  - CNI: Recommended. Requires more network planning and IP allocation, and provides ability for inboud communication into the nodes
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
  - Logging to STOUT
- Application Insights

### Other

- Watch-out for Issues with Upstream features 

### Resources

- http://aksworkshop.io/

## Other Azure Services

### Application Gateway as Ingress Controller

- https://github.com/Azure/application-gateway-kubernetes-ingress

### Azure Container Registry

- Use it to store the images
  - The premium sku provides ability to have global replication of the images and thus images can be used on ASK cluster on different regions

### Azure Key Vault

- Use it to store and retrieve secrets

