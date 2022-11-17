#!/bin/bash

# Install argocd
kubectl apply -n ${namespace} -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# patch --insecure to allow http
kubectl patch deployment \
  argocd-server \
  --namespace ${namespace} \
  --type='json' \
  -p='[{"op": "add", "path": "/spec/template/spec/containers/0/command", "value": ["argocd-server","--insecure"]}]'

#Install gateway and virtualservice
kubectl apply -n ${namespace} -f ./argocd-virtualservice.yaml