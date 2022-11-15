
variable "cluster_name" {
  default = "CRP2-AKS-Demo"
}
variable "kube_version" {
  default = "1.22"
}
variable "dns_prefix" {
  default = "crp2"
}
variable "resource_group_name" {
  default = "CRP2-Demo"
}
variable "location" {
  default = "eastus"
}

variable "tags" {
  type    = map(string)
  default = { Environment = "CRP2-AKS-Demo" }
}
variable "client_secret" {
  type      = string
  sensitive = true
}

variable "client_id" {
  type = string
}

variable "tenant_id" {
  type = string
}

variable "subscription_id" {
  type = string
}