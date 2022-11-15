
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
variable "client_id" {
  default = "8d438cd7-e9ae-4f1b-8bd3-a2bc0a274da0"
}
variable "client_secret" {
  default = "NW6V_n1avBcfZnm7TUqbZ6v-L9bs8mJYOC"
}
variable "tags" {
  type    = map(string)
  default = { Environment = "CRP2-AKS-Demo" }
}