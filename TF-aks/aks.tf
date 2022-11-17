resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.cluster_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = var.dns_prefix
  kubernetes_version  = var.kube_version

  default_node_pool {
    name                  = "default"
    node_count            = 2
    vm_size               = "Standard_D2_v2"
    os_disk_size_gb       = 50
    enable_node_public_ip = true

  }

  identity {
    type = "SystemAssigned"
  }

  role_based_access_control_enabled = true

  tags = var.tags
}


resource "azurerm_container_registry" "acr" {
  name                   = "trungnguyenprojectcrp2"
  resource_group_name    = azurerm_resource_group.rg.name
  location               = azurerm_resource_group.rg.location
  admin_enabled          = true
  anonymous_pull_enabled = true

  sku  = "Standard"
  tags = var.tags
}
