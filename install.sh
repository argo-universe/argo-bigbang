#!/bin/bash

if [[ $# -eq 0 ]] ; then
    echo 'Please provide an environment parameter (e.g. dev, stage, prod)'
    exit 1
fi

ENV=$1
BRANCH=${2:-main} # Set default value "main" if second argument is not provided

# Set environment variable
export ENV=$ENV

# Create Kubernetes namespaces for ArgoCD and Ingress
ARGOCD_NAMESPACE="argocd"
if ! kubectl get ns $ARGOCD_NAMESPACE 2> /dev/null ; then
    kubectl create ns $ARGOCD_NAMESPACE
fi

# install ArgoCD
cd bigbang/cluster-addons/argocd
helm dependency build
helm upgrade --install argocd . \
    -f values.$ENV.yaml \
    -n argocd 

# Wait for the Deployment to be ready
echo "Waiting for Deployment to be ready..."
kubectl wait --for=condition=available --timeout=300s deployment/argocd-server -n argocd


# Install BigBang application using the Helm chart from the local repository
cd ../../..
helm upgrade --install bigbang-app bigbang/bigbang-app -n $ARGOCD_NAMESPACE \
    --set env=$ENV \
    --set targetRevision=$BRANCH 
