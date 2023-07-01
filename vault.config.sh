#!/bin/bash

VAULT_ROOT_TOKEN="$1"

if [[ -n "$VAULT_ROOT_TOKEN" ]]; then
    namespaces=("argocd" "backend" "cert-manager" "frontend" "ingress" "internal" "vault" "monitoring")

    for namespace in "${namespaces[@]}"; do
        kubectl create secret generic vault-token \
            --from-literal="token=$VAULT_ROOT_TOKEN" \
            -n "$namespace"
    done
else
    echo "VAULT_ROOT_TOKEN not provided. Please pass the token as an argument when running the script."
fi
