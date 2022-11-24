#!/bin/bash

#install Argo Rollout
kubectl apply -n ${namespace} -f https://github.com/argoproj/argo-rollouts/releases/latest/download/install.yaml

#wait until argocd server & argo-rollouts are ready
kubectl -n argocd wait pods -l app.kubernetes.io/name=argocd-server --for condition=Ready --timeout=60s
kubectl -n argocd wait pods -l app.kubernetes.io/name=argo-rollouts --for condition=Ready --timeout=60s

#Get credential to argocd
argocd_pwd=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)
hostname=$(kubectl get service istio-ingressgateway -n istio-ingress --output=jsonpath='{.status.loadBalancer.ingress[0].ip}')
argocd login --username admin --password ${argocd_pwd} --grpc-web --insecure --plaintext ${hostname}:80

#Install blue-green app using test-ci
argocd app create --name app-blue-green --repo https://github.com/ngdtrunguit/forCRP2.0.git --dest-server https://kubernetes.default.svc --dest-namespace application --path test-ci && argocd app sync app-blue-green
