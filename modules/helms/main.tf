resource "helm_release" "chart" {
  for_each = var.helms

  name       = each.key
  version    = each.value.chart_version
  chart      = each.value.chart
  repository = each.value.repository
  namespace  = each.value.namespace

  dynamic set {
    for_each = var.helms[each.key].sets
    content {
      name  = set.value.name
      value = set.value.value
    }
  }
}