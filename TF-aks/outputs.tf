output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "kubernetes_cluster_name" {
  value = azurerm_kubernetes_cluster.aks.name
}

output "host" {
  value     = azurerm_kubernetes_cluster.aks.kube_config.0.host
  sensitive = true
}

output "client_key" {
  value     = azurerm_kubernetes_cluster.aks.kube_config.0.client_key
  sensitive = true
}

output "client_certificate" {
  value     = azurerm_kubernetes_cluster.aks.kube_config.0.client_certificate
  sensitive = true
}
output "cluster_ca_certificate" {
  sensitive = true
  value     = azurerm_kubernetes_cluster.aks.kube_config[0].cluster_ca_certificate
}

output "kube_config" {
  value     = azurerm_kubernetes_cluster.aks.kube_config_raw
  sensitive = true
}

output "cluster_username" {
  value     = azurerm_kubernetes_cluster.aks.kube_config.0.username
  sensitive = true
}

output "cluster_password" {
  value     = azurerm_kubernetes_cluster.aks.kube_config.0.password
  sensitive = true
}

output "id" {
  description = "The Container Registry ID."
  value       = azurerm_container_registry.acr.id
}

output "login_server" {
  description = "The URL that can be used to log into the container registry."
  value       = azurerm_container_registry.acr.login_server
}

output "admin_username" {
  description = "The Username associated with the Container Registry Admin account - if the admin account is enabled"
  value       = azurerm_container_registry.acr.admin_username
}

output "admin_password" {
  description = "The Password associated with the Container Registry Admin account - if the admin account is enabled."
  #sensitive = true
  value = azurerm_container_registry.acr.admin_password
}