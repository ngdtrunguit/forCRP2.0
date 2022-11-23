#!/bin/bash

#install jenkins
helm repo add jenkins https://charts.jenkins.io
helm repo update

helm -n ${namespace} upgrade --install jenkins jenkins/jenkins --values values-jenkins.yaml


kubectl create secret docker-registry docker-credentials \
 --docker-server=trungnguyenprojectcrp2.azurecr.io \
 --docker-username=trungnguyenprojectcrp2 \
 --docker-password=${acr_pwd} \
 --docker-email=ngdtrunguit@gmail.com \
 --namespace jenkins

 kubectl apply -n ${namespace} -f ./jenkins-virtualservice.yaml