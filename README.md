# **forCR2.0  AKS** 

## ---------Container Runtime Platform AKS (IaC, CICD, Service Mesh)------------ ##

### _All the infrastructure and applications setup by Github Action with Terraform_

- Cloud provider: Azure
- IaC tool: Terraform
- Pipeline: Github Action, ArgoCD, Argo Rollouts, Jenkins
- Source code: Github
- Container images: Azure Container Registry 

![CRP2.0 diagram](https://github.com/ngdtrunguit/forCRP2.0/blob/main/docs/CRP2-demo.png)

> Note: github action will be trigger manually by workflow_dispatch or auto trigger by push/pull_requests
> ```sh 
> on:
>  push:
>    branches: [ "main" ]
>  pull_request:
>    branches: [ "main" ]
>  workflow_dispatch:
> ```


## Step 1: Setup remote state for Terraform
Using terraform to create remote state backend on Azure Storage. Two main containers for aks and application

[Github-action.tf-backend](https://github.com/ngdtrunguit/forCRP2.0/blob/main/.github/workflows/tf-backend.yml)

[TF-init-state](https://github.com/ngdtrunguit/forCRP2.0/blob/main/tf-init-state)

```sh
- tfstate for aks tfstate-aks
- tfstate for helm tfstate-helm
``` 

## Step 2: Create Azure Kubernetes Service and Azure Container Registry by Terraform

[Github-action.tf-aks](https://github.com/ngdtrunguit/forCRP2.0/blob/main/.github/workflows/tf-aks.yml)

Create a service principal and set information in github secret
```sh 
az ad sp create-for-rbac --name <name> --role Contributor --scopes /subscriptions/<subscription-id> --sdk-auth

{
  "clientId": "",
  "clientSecret": "",
  "subscriptionId": "",
  "tenantId": "",
}
```
> After AKS provisioned, use these command to access kubernetes cluster:
>  ```sh
> az aks get-credentials --resource-group <resouregroup_name> --name <kubernetes_cluster_name>
> kubectl get ns # to check if it work



## Step 3: Install istio service mesh and argocd, argo rollouts using Terraform helm/kubernetes provider
 
[Github-action.tf-helm](https://github.com/ngdtrunguit/forCRP2.0/blob/main/.github/workflows/tf-helm.yml)

> This step will use helm and kubernetes providers
> ```sh
> resource "kubernetes_namespace" "application" {
> }
> resource "helm_release" "istiod" {
> }
> resource "null_resource" "argocd" {
> }
> ```
> combines with _sh_ to install:
1. Istio service mesh 
2. ArgoCD with virtualservice
3. Argo Rollouts
4. Create/manage Blue-Green app in application namespace using ArgoCD
   > Note that I am using virtualservice for blue-green app. At the time of creation, I do not use dns for istio virtualservice. So, I add these records to /etc/hosts for testing activity 
   ``` sh
   <loadbalancer_ip>    blue.app.com
   <loadbalancer_ip>    green.app.com
   ```


## Step 4: Setup CI/CD pipeline to handle the blue/green deployment strategy for application

[Github-action.docker-to-ACR](https://github.com/ngdtrunguit/forCRP2.0/blob/main/.github/workflows/docker-to-ACR.yml)

> ### _Using Github action to build docker **CI** and push to ACR_

- Image will be automatically build by push and pull_requests or trigger manually on main branch. Tag number will be github runner build
- Update tag number for image on Values.yaml automatically 

- There is still one step should be done manually:
   - Promote new build on ArgoCD when testing activity done. 
  
>  ArgoCD will automate sync and argo rollout will take care for Blue-Green deployment **(CD)**

## Step 5: Another option for CI/CD pipeline (Jenkins) to handle the blue/green deployment strategy for application
> This option use Jenkins to build CI and tag image build number and push it to ACR, update values.yaml in Helm repo, ArgoCD then trigger build to Kubernetes

> Install Jenkins by null_resource
```sh
resource "null_resource" "jenkins" 
```
- Jenkins pipeline and CI stored in [jenkins-ci](https://github.com/ngdtrunguit/forCRP2.0/blob/main/jenkins-ci)

