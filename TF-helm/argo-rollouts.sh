#!/bin/bash




kubectl apply -n ${namespace} -f https://github.com/argoproj/argo-rollouts/releases/latest/download/install.yaml


argocd_pwd=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)
# argocd_pwd="adminadmin"
hostname=$(kubectl get service istio-ingressgateway -n istio-ingress --output=jsonpath='{.status.loadBalancer.ingress[0].ip}')
argocd login --username admin --password ${argocd_pwd} --grpc-web --insecure --plaintext ${hostname}:80

#install blue-green app
# argocd app create --name blue-green --repo https://github.com/argoproj/argocd-example-apps --dest-server https://kubernetes.default.svc --dest-namespace application --path blue-green && argocd app sync blue-green
argocd app create --name blue-green --repo https://github.com/ngdtrunguit/Tim-lab.git --dest-server https://kubernetes.default.svc --dest-namespace application --path blue-green && argocd app sync blue-green