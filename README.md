<h1>Argo-Bigbang</h1>

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://github.com/makdeniz/argo-bigbang/blob/master/LICENSE)
ArgoCD boilerplate is used to deploy to ArgoCD elegantly. This repository will deploy all the basic components of a common Kubernetes cluster and a sample microservice to provide insight into the architecture of GitOps. By manually executing the shell script or executing it through a pipeline, you will be able to deploy all the required components for your cluster.

These are the basic components that will be deployed, but not limited to:

* nginx-ingress
* external secrets
* a sample microservice
    * the microservice will be deployed from a separate repository to keep the cluster from the applications.
    
Once the installation script is executed, the resources below will be installed automatically.

#### Component Diagram

```mermaid
graph TD
    A(exucute install.sh) --> B(ArgoCD)
    A--> BB(Bigbang App)
    BB --> CA(Cluster Addons ApplicationSet)
    BB --> MS(Microservices ApplicationSet)
    CA--> AC(ArgoCD)
    CA--> ING(Nginx-ingress)
    CA--> ES(External Secrets)
    MS--> SA(Sample Micro Service)
```
#### Folder Structure and Environment Variables

Every cluster addon has several environment files. When the application set tries to deploy addons or microservices, it looks for two files. The first one is the values.yaml file, and the second file is values.**[environment]**.yaml file. The environment file will override the values on the values.yaml file.

/cluster-addons
├── /argocd
│   ├── Chart.yaml
│   ├── values.yaml
│   ├── values.**dev**.yaml
│   ├── values.**qa**.yaml
│   ├── values.**staging**.yaml
│   └── values.**prod**.yaml
├── /nginx-ingress
│   ├── Chart.yaml
│   ├── values.yaml
│   ├── values.**dev**.yaml
│   ├── values.**qa**.yaml
│   ├── values.**staging**.yaml
│   └── values.**prod**.yaml
├── /external-secrets
│   ├── Chart.yaml
│   ├── values.yaml
│   ├── values.**dev**.yaml
│   ├── values.**qa**.yaml
│   ├── values.**staging**.yaml
│   └── values.**prod**.yaml


## Installation

 run install.sh file with environment name
``` bash
 $ ./install.sh dev
```
## Usage

depending on your configuration use portforward or ingress to access argocd UI.

## License

This project is licensed under the [MIT License](https://opensource.org/licenses/MIT).

## Contributing

We welcome issues and PRs!