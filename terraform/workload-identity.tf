## To create dependencies between the workload identity and the cluster.
## In this example we will create K8s resources too,
## so we need to wait for the cluster to be ready and refresh the provider config.

data "azurerm_kubernetes_cluster" "this" {
  name                = "${local.prefix}-aks"
  resource_group_name = azurerm_resource_group.aks.name
  depends_on = [
    module.argocd
  ]
}

provider "kubernetes" {
  host                   = data.azurerm_kubernetes_cluster.this.kube_config.0.host
  cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.this.kube_config.0.cluster_ca_certificate)

  # using kubelogin to get an AAD token for the cluster.
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "kubelogin" ## need kubelogin installed on the machine where terraform is running
    args = [
      "get-token",
      "--environment",
      "AzurePublicCloud",
      "--server-id",
      "6dae42f8-4368-4678-94ff-3960e28e3630", # (application used by the server side) https://azure.github.io/kubelogin/concepts/aks.html
      "--client-id",
      "80faf920-1908-4b52-b5ef-a8e7bedfc67a", # (public client application used by kubelogin) https://azure.github.io/kubelogin/concepts/aks.html
      "--tenant-id",
      var.tenant_id, # AAD Tenant Id
      "--login",
      "devicecode" ## expected to work only from local machine ( NO CI/CD )
    ]
  }
}

## source: https://github.com/ishuar/terraform-azure-workload-identity
## TF registry: https://registry.terraform.io/modules/ishuar/workload-identity/azure/latest
module "workload_identity" {
  for_each = { for identity in local.identities : identity.service_account_name => identity }

  source               = "ishuar/workload-identity/azure"
  version              = "0.3.0"
  resource_group_name  = azurerm_resource_group.aks.name
  location             = azurerm_resource_group.aks.location
  oidc_issuer_url      = data.azurerm_kubernetes_cluster.this.oidc_issuer_url
  service_account_name = each.value.service_account_name
  namespace            = each.value.namespace
  role_assignments     = each.value.role_assignments

  depends_on = [
    module.argocd,
    data.azurerm_kubernetes_cluster.this,
    azurerm_role_assignment.cluster_admin
  ]
}
