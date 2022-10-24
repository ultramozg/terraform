resource "cockroach_cluster" "cockroach" {
  name           = "cockroach-test"
  cloud_provider = "AWS"
  create_spec = {
    dedicated: {
      region_nodes = {
        "eu-west-1": 3
      }
      hardware = {
        storage_gib = 15
        machine_spec = {
          machine_type = "m5.large"
        }
      }
    }
  }
  wait_for_cluster_ready = true
}

resource "cockroach_sql_user" "cockroach" {
  id       = cockroach_cluster.cockroach.id
  name     = "test-user"
  password = "sdfsdfsd34543@#$@#$@#"
}