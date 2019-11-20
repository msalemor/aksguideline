# Docker, AKS, and Other Azure Services

A guide to best practices for Docker, AKS, and other Azure Services

## Microservices architecture

### API Management pattern

### Async vs Sync patterns

### Resiliency

### 12 Factor

### Resources

- https://docs.microsoft.com/en-us/dotnet/architecture/microservices/


## Docker

### Security

- Update the base images regularly
- Don't run all processes as root
- Use container registry services to scan for vulnerabilities

## AKS

### Provisioning

- Provision the cluster with the Azure CLI as it provides more configuration options
- Enable autoscaling of nodes

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

### Security

- Patch the nodes

### Resource Limits

- Set resource limits on PODs
  - k8s will deprevision PODs without resource limits first

### Resources

- http://aksworkshop.io/

## Other Azure Services

### Azure Container Registry

### Azure

