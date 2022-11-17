#forCRP2-AKS
## ---------CRP2 AKS (IaC, CICD, Service Mesh)------------ ##

### All the infrastructure and applications setup by github action with terraform

- Cloud provider: Azure
- IaC tool: Terraform
- Pipeline: Github Action, ArgoCD, Argo Rollouts
- Source code: Github
- Container images: Azure Container Registry 

## Step 1: Setup remote state for Terraform
Using terraform to create remote state backend on Azure Storage. Two main containers for aks and application

[TF-init-state] (https://github.com/ngdtrunguit/forCRP2.0/blob/main/tf-init-state)

```sh
- tfstate for aks tfstate-aks
- Tfstate for helm tfstate-aks
``` 

## Step 2: Create AKS and ACR by terraform

az account set --subscription az aks get-credentials --resource-group --name kubectl get ns


## Step 3: Install istio service mesh and argocd, argo rollout using Terraform helm/kubernetes provider
 

Install istio service mesh on AKS
create istio-system/istio-ingress namespace 

create argocd namspace with label istio-injection = "enabled"
install istio/argocd by tf-helm
install argo rollout by tf-helm (for Green/Blue deployment)
Modify script sh to install app-blue-green




## Step 4: Setup CI/CD pipeline to handle the blue/green deployment strategy for application

Using github action to build docker CI and push to ACR

Update tag number for image on Values.yaml 

=> argocd will automate sync and argo rollout help to scale up replicaset for preview services.

Manually promote new build on ArgoCD when testing activity done. 
