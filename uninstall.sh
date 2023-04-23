# Uninstall the BigBang application
helm uninstall bigbang-app -n argocd

# Uninstall ArgoCD
helm uninstall argocd -n argocd

# Delete the 'argocd' and 'ingress' namespaces
# kubectl delete ns argocd
# kubectl delete ns ingress