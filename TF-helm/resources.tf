data "azurerm_resource_group" "aks_rg" {
  name = "CRP2-Demo"
}

data "azurerm_kubernetes_cluster" "aks_cluster" {
  name                = "CRP2-AKS-Demo"
  resource_group_name = data.azurerm_resource_group.aks_rg.name
}
resource "local_file" "kube_config" {
  content  = data.azurerm_kubernetes_cluster.aks_cluster.kube_admin_config_raw
  filename = ".kube/config"
}

provider "helm" {
  kubernetes {
    host                   = data.azurerm_kubernetes_cluster.aks_cluster.kube_config.0.host
    client_certificate     = base64decode(data.azurerm_kubernetes_cluster.aks_cluster.kube_config.0.client_certificate)
    client_key             = base64decode(data.azurerm_kubernetes_cluster.aks_cluster.kube_config.0.client_key)
    cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.aks_cluster.kube_config.0.cluster_ca_certificate)
  }
}

provider "kubernetes" {
  host                   = data.azurerm_kubernetes_cluster.aks_cluster.kube_config.0.host
  client_certificate     = base64decode(data.azurerm_kubernetes_cluster.aks_cluster.kube_config.0.client_certificate)
  client_key             = base64decode(data.azurerm_kubernetes_cluster.aks_cluster.kube_config.0.client_key)
  cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.aks_cluster.kube_config.0.cluster_ca_certificate)
}

resource "kubernetes_namespace" "istio_system" {
  metadata {
    annotations = {
      name = "istio-ingress"
    }
    name = "istio-system"
  }
}

resource "kubernetes_namespace" "istio-ingress" {
  metadata {
    annotations = {
      name = "istio-ingress"
    }

    labels = {
      istio-injection = "enabled"
    }

    name = "istio-ingress"
  }
}

resource "kubernetes_namespace" "application" {
  metadata {
    annotations = {
      name = "application"
    }

    labels = {
      istio-injection = "enabled"
    }

    name = "application"
  }
}

resource "kubernetes_namespace" "argocd" {
  metadata {
    annotations = {
      name = "argocd"
    }

    labels = {
      istio-injection = "enabled"
    }

    name = "argocd"
  }
}

resource "kubernetes_namespace" "argo-rollouts" {
  metadata {
    annotations = {
      name = "argo-rollouts"
    }

    labels = {
      istio-injection = "enabled"
    }

    name = "argo-rollouts"
  }
}

resource "kubernetes_namespace" "jenkins" {
  metadata {
    annotations = {
      name = "jenkins"
    }

    labels = {
      istio-injection = "enabled"
    }

    name = "jenkins"
  }
}

resource "helm_release" "istio-base" {
  name            = "istio-base"
  namespace       = kubernetes_namespace.istio_system.metadata.0.name
  cleanup_on_fail = true
  repository      = "https://istio-release.storage.googleapis.com/charts"
  chart           = "base"
  depends_on      = [kubernetes_namespace.istio_system]

}

resource "helm_release" "istiod" {
  name            = "istiod"
  namespace       = kubernetes_namespace.istio_system.metadata.0.name
  cleanup_on_fail = true
  repository      = "https://istio-release.storage.googleapis.com/charts"
  chart           = "istiod"
  depends_on      = [kubernetes_namespace.istio_system, helm_release.istio-base]
}

resource "helm_release" "istio-ingressgateway" {
  name            = "istio-ingressgateway"
  namespace       = kubernetes_namespace.istio-ingress.metadata.0.name
  cleanup_on_fail = true
  repository      = "https://istio-release.storage.googleapis.com/charts"
  chart           = "gateway"
  depends_on      = [kubernetes_namespace.istio-ingress, helm_release.istio-base, helm_release.istiod]
}

resource "null_resource" "argo-rollouts" {
  provisioner "local-exec" {
    command = file("./argo-rollouts.sh")
    environment = {
      namespace = "${kubernetes_namespace.argo-rollouts.metadata.0.name}"
    }
  }
  depends_on = [helm_release.istio-base, helm_release.istiod, helm_release.istio-ingressgateway, kubernetes_namespace.argocd, kubernetes_namespace.argo-rollouts, null_resource.argocd]
}

resource "null_resource" "argocd" {
  provisioner "local-exec" {
    command = file("./argocd.sh")
    environment = {
      namespace = "${kubernetes_namespace.argocd.metadata.0.name}"
    }
  }
  depends_on = [helm_release.istio-base, helm_release.istiod, helm_release.istio-ingressgateway, kubernetes_namespace.argocd]
}

data "azurerm_container_registry" "acr" {
  name                = "trungnguyenprojectcrp2"
  resource_group_name = data.azurerm_resource_group.aks_rg.name
}

resource "null_resource" "jenkins" {
  triggers = {
    always_run = "${timestamp()}"
  }
  provisioner "local-exec" {
    command = file("./jenkins.sh")
    environment = {
      namespace = "${kubernetes_namespace.jenkins.metadata.0.name}"
      acr_pwd   = "${data.azurerm_container_registry.acr.admin_password}"
    }
  }
  depends_on = [helm_release.istio-base, helm_release.istiod, helm_release.istio-ingressgateway, kubernetes_namespace.jenkins]
}

data "external" "argocd_pwd" {
  program    = ["bash", "./argocd-get-pwd.sh"]
  depends_on = [helm_release.istio-base, helm_release.istiod, helm_release.istio-ingressgateway, kubernetes_namespace.argocd, null_resource.argocd, null_resource.argo-rollouts]
}