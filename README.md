<h1>Argo-Bigbang</h1>

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://github.com/makdeniz/argo-bigbang/blob/master/LICENSE) [![GitHub stars](https://img.shields.io/github/stars/makdeniz/argo-bigbang.svg?style=social)](https://github.com/makdeniz/argo-bigbang)

Argocd boiler plate to deploy to ArgoCd with elagant way.

## Description

This repo contains all the neccesary component and configuration to deploy argocd to a kubernetes cluster along with basic following cluster addons:

* nginx-ingress
* external secrets
* a sample application

once the istallation script executed resources below will be installed automatically

```mermaid
graph TD
    A(exucute install.sh) --> B(ArgoCD)
    A--> BB(Bigbang App)
    BB --> CA(Cluster Addons ApplicationSet)
    BB --> MS(Microservices ApplicationSet)
    CA--> AC(Argocd)
    CA--> ING(Nginx-ingress)
    CA--> ES(External Secrets)
    MS--> SA(Sample Micro Service)
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