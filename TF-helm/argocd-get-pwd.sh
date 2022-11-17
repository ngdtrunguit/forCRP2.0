#!/bin/bash

#get initialize password for argocd
argocd_pass=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo)
token=${argocd_pass}

jq -n --arg token ${token} '{"token":$token}'