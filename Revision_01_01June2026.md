# Learning Progress - 01 June 2026

## Topics Revised

### AWS

* VPC Route Tables and Internet Gateway
* Public vs Private Subnets
* Restricting outbound internet access using route tables
* Amazon S3 Durability (11 9's)
* Durability vs Availability

### Kubernetes

* Kubernetes Manifest Files
* Deployment YAML structure
* Relationship between Git, Docker Images, CI/CD and Kubernetes manifests

### Linux & Containers

* Namespaces (Process, Network, Filesystem Isolation)
* cgroups (CPU and Memory Resource Limits)

### Docker

* Dockerfile Structure
* FROM, RUN, WORKDIR, COPY, ENV, EXPOSE, CMD
* CMD vs ENTRYPOINT
* Docker Build and Image Tagging (-t)
* COPY vs ADD

### Docker Storage

* Why S3 cannot be directly mounted as a Docker Volume
* Using s3fs to mount S3 buckets

### Docker Networking

* Bridge Network
* Host Network
* Overlay Network
* docker0 Bridge
* Custom Bridge Networks
* veth Pair
* Network Isolation for Sensitive Applications

### Docker Compose

* Multi-container application management
* docker-compose.yml structure
* Services, Networks, Volumes and Environment Variables
* Docker Compose lifecycle commands

## Key Takeaways

* Namespaces provide container isolation.
* cgroups control resource consumption.
* docker0 acts as a virtual switch.
* veth pairs act as virtual network cables.
* Custom bridge networks improve isolation and security.
* Docker Compose simplifies running multiple containers together.
* Kubernetes manifests define the desired state of applications.
* S3 is object storage, not a filesystem.

