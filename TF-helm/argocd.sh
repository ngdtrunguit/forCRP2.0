#!/bin/bash
set -euo pipefail

kubectl apply -n ${namespace} -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml


kubectl patch deployment \
  argocd-server \
  --namespace ${namespace} \
  --type='json' \
  -p='[{"op": "add", "path": "/spec/template/spec/containers/0/command", "value": ["argocd-server","--insecure"]}]'

kubectl apply -n ${namespace} -f ./argocd-gateway.yaml

kubectl apply -n ${namespace} -f ./argocd-virtualservice.yaml