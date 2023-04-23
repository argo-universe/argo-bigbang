#!/bin/bash

if [[ $# -eq 0 ]] ; then
    echo 'Please provide an environment parameter (e.g. dev, stage, prod)'
    exit 1
fi

ENV=$1

# Set environment variable
export ENV=$ENV

# Create Kubernetes namespaces for ArgoCD and Ingress
kubectl create ns argocd  

# Add ArgoCD Helm repository
helm repo add argo https://argoproj.github.io/argo-helm

# Install ArgoCD using the Helm chart from the ArgoCD Helm repository
helm upgrade --install argocd argo/argo-cd \
    -f bigbang/cluster-addons/argocd/values.$ENV.yaml \
    -n argocd \
    --version 5.16.10 

# Install BigBang application using the Helm chart from the local repository
helm upgrade --install bigbang-app bigbang/bigbang-app -n argocd --set env=$ENV
