output "argocd_secret" {
  value = data.external.argocd_pwd.result
}