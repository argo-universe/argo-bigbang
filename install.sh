#!/bin/bash

# Optional: Set Git credentials for privat repositories 
REPO_USER=$GITHUB_USER 
REPO_PASSWORD=$GITHUB_PAT
REPO_URL=$GITHUB_URL

if [[ $# -eq 0 ]] ; then
    echo 'Please provide an environment parameter (e.g. dev, stage, prod)'
    exit 1
fi

ENV=$1
BRANCH=${2:-main} # Set default value "main" if second argument is not provided

# Set environment variable
export ENV=$ENV

# Create Kubernetes namespaces for ArgoCD and Ingress
kubectl create ns argocd  

# install ArgoCD
cd bigbang/cluster-addons/argocd
helm upgrade --install argocd . \
    -f values.$ENV.yaml \
    -n argocd 

# Wait for the Deployment to be ready
echo "Waiting for Deployment to be ready..."
kubectl wait --for=condition=available --timeout=300s deployment/argocd-server -n argocd

# To use privat Git Repositories, add a Secret with the git credentials 
# and the `argocd.argoproj.io/secret-type` label.
if [[ ! -z "$REPO_USER" && ! -z "$REPO_PASSWORD" && ! -z "$REPO_URL" ]]; then
    kubectl create secret generic git-repo-creds -n argocd \
    --from-literal=password=$REPO_PASSWORD \
    --from-literal=url=$REPO_URL \
    --from-literal=username=$REPO_USER

    kubectl label secret git-repo-creds -n argocd  "argocd.argoproj.io/secret-type=repository"
fi

# Install BigBang application using the Helm chart from the local repository
cd ../../..
helm upgrade --install bigbang-app bigbang/bigbang-app -n argocd \
    --set env=$ENV \
    --set targetRevision=$BRANCH 

# Echo Argocd admin password
ArgoCDAdminPassword=$(kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 -d)
echo "ArgoCD admin password is $ArgoCDAdminPassword"
