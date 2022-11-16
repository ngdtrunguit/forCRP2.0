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
# resource "null_resource" "set-kube-config" {
#   triggers = {
#     always_run = "${timestamp()}"
#   }
#   provisioner "local-exec" {
#     command = "az aks get-credentials -n ${data.azurerm_kubernetes_cluster.aks_cluster.name} -g ${data.azurerm_resource_group.aks_rg.name} --file \".kube/${data.azurerm_kubernetes_cluster.aks_cluster.name}\" --admin --overwrite-existing"
#   }
#   depends_on = [local_file.kube_config]
# }

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
  depends_on      = [helm_release.istio-base]
}

resource "helm_release" "istio-ingressgateway" {
  name            = "istio-ingressgateway"
  namespace       = kubernetes_namespace.istio-ingress.metadata.0.name
  cleanup_on_fail = true
  repository      = "https://istio-release.storage.googleapis.com/charts"
  chart           = "gateway"
  depends_on      = [helm_release.istio-base, helm_release.istiod]
}

resource "null_resource" "argo-rollout" {
  # triggers = {
  #   always_run = "${timestamp()}"
  # }
  provisioner "local-exec" {
    command = file("./argo-rollouts.sh")
    environment = {
      namespace = "${kubernetes_namespace.argo-rollouts.metadata.0.name}"
      # kubeconfig = ".kube/${data.azurerm_kubernetes_cluster.aks_cluster.name}"
    }
  }
  depends_on = [kubernetes_namespace.argo-rollouts]
}

resource "null_resource" "argocd" {
  provisioner "local-exec" {
    command = file("./argocd.sh")
    environment = {
      namespace = "${kubernetes_namespace.argocd.metadata.0.name}"
      # kubeconfig = ".kube/${data.azurerm_kubernetes_cluster.aks_cluster.name}"
    }
  }
  depends_on = [helm_release.istio-base, helm_release.istiod, helm_release.istio-ingressgateway, kubernetes_namespace.argocd]
}

data "external" "argocd_pwd" {
  program = ["bash", "./argocd-get-pwd.sh"]
  # query = {
  #   "kubeconfig" = ".kube/${data.azurerm_kubernetes_cluster.aks_cluster.name}"
  # }
  depends_on = [null_resource.argocd]
}