#!/bin/bash

# Check dependencies
if ! command -v kubectl >/dev/null 2>&1; then
  echo "kubectl is required but not installed. Aborting."
  exit 1
fi

if ! command -v vault >/dev/null 2>&1; then
  echo "vault is required but not installed. Aborting."
  exit 1
fi

# Port forward to Vault service
kubectl port-forward svc/vault -n vault 8200:8200 &

# Store the process ID of the port forward
port_forward_pid=$!

# Wait for the port forward to be established
sleep 10

# Initialize Vault and retrieve unseal keys and root token
init_output=$(vault operator init -format=json -address=http://127.0.0.1:8200)

echo "$init_output"

# Extract unseal keys and root token from the output
unseal_keys=($(echo "$init_output" | jq -r '.unseal_keys_b64[]'))
root_token=$(echo "$init_output" | jq -r '.root_token')

# Unseal Vault using the unseal keys
for unseal_key in "${unseal_keys[@]}"; do
  vault operator unseal -address="http://127.0.0.1:8200" "$unseal_key"
done

# Output the root token
echo "Root Token: $root_token"

if [[ -n "$root_token" ]]; then
  # Define namespaces
  namespaces=("argocd" "backend" "cert-manager" "frontend" "ingress" "vault" "monitoring")

  # Create secret in each namespace
  for namespace in "${namespaces[@]}"; do
    kubectl create secret generic vault-token \
      --from-literal="token=$root_token" \
      -n "$namespace"
  done
else
  echo "ROOT_TOKEN not provided. Please pass the token as an argument when running the script."
fi

# Kill the port forward process
kill $port_forward_pid
