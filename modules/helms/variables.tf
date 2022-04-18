variable helms {
  type = map(object({
    chart         = string
    namespace     = string
    chart_version = string
    repository    = string
    sets = list(object({
      name  = string
      value = string
    }))
  }))
}