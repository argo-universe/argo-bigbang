# Argo-Bigbang
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://github.com/makdeniz/argo-bigbang/blob/master/LICENSE)

<img src="https://cncf-branding.netlify.app/img/projects/argo/horizontal/color/argo-horizontal-color.png" height="100" alt="" /> 

Argo-Bigbang is a boilerplate used to deploy your entire assets with single command using ArgoCD elegantly. This repository will deploy all the basic components of a common Kubernetes cluster and a sample microservice to provide insight into the architecture of GitOps. By manually executing the shell script or executing it through a pipeline, you will be able to deploy all the required components for your cluster.

These are the basic components that will be deployed, but not limited to:

* nginx-ingress
* external secrets
* a sample microservice
    * the microservice will be deployed from a separate repository to keep the cluster from the applications.
    
Once the installation script is executed, the resources below will be installed automatically.

#### Component Diagram
> **INFO:** Since the applicationset is configuret to generate an application for each folder in cluster addons. If you need to deploy another component just create a folder with environment value file 

```mermaid
graph TD
    style CA fill:lightgreen,stroke:#333,stroke-width:1px
    style MS fill:lightgreen,stroke:#333,stroke-width:1px

    A(exucute install.sh) --> B(ArgoCD)
    A--> BB(Bigbang App)
    BB --> CA(Cluster Addons ApplicationSet)
    BB --> MS(Microservices ApplicationSet)
    CA--> AC(ArgoCD)
    CA--> ING(Nginx-ingress)
    CA--> ES(External Secrets)
    MS--> SA(Sample Micro Service)
```


### Sequence Diagram
```mermaid
sequenceDiagram
    install.sh->>+install.sh: Create argocd namespace
    install.sh->>+Argocd: Install ArgoCD application
    install.sh->>+Bigbang App: Install Bigbang App
    Bigbang App->>+Cluster Addons ApplicationSet: Install Install ApplicationSets
    Bigbang App->>+Microservices ApplicationSet: Install Install ApplicationSets
    loop Foreach folder under remote repo
    Microservices ApplicationSet->>+Argocd: Generate Microservice Apps
    end
    loop Foreach folder under cluster-addons folder 
    Cluster Addons ApplicationSet->>+Argocd: Generate Cluster Addons Apps
    end
```

  


#### Folder Structure and Environment Variables

Every cluster addon has several environment files. When the application set tries to deploy addons or microservices, it looks for two files. The first one is the values.yaml file, and the second file is values.**[environment]**.yaml file. The environment file will override the values on the values.yaml file.


```mermaid
graph LR
    style DEV fill:lightgreen,stroke:#333,stroke-width:1px
    style QA fill:orange,stroke:#333,stroke-width:1px
    style STG fill:yellow,stroke:#333,stroke-width:1px
    style PROD fill:red,stroke:#333,stroke-width:1px

    R[fa:fa-folder cluster-addons] --> ADDON[fa:fa-folder Addons: argocd]
    ADDON --> A0[fa:fa-file Chart.yaml]
    ADDON --> A1[fa:fa-file Chart.lock]
    ADDON --> A2[fa:fa-file values.yaml]
    ADDON --> DEV[fa:fa-file values.dev.yaml]
    ADDON --> QA[fa:fa-file values.qa.yaml]
    ADDON --> STG[fa:fa-file values.staging.yaml]
    ADDON --> PROD[fa:fa-file values.prod.yaml] 
     
```


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