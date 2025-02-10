resource "helm_release" "keda" {
  name       = "keda"
  namespace  = "keda"
  repository = "https://kedacore.github.io/charts"
  chart      = "keda"
  version    = "2.11.0"  # You can specify the version if necessary
  create_namespace = true

  values = [
    # Add any values that you would like to override
    # For example, the KEDA operator image version
    <<-EOT
    operator:
      image:
        tag: "2.11.0"  # You can specify the version of the operator here
    EOT
  ]

  
}