resource "consul_acl_policy" "terraform-storage" {
  name  = "terraform-storage"
  rules = <<-RULE
    key_prefix "terraform/" {
      policy = "write"
    }
    RULE
}

resource "consul_acl_token" "terraform-storage" {
  description = "Token for Terraform's Consul state backend"
  policies = [
    consul_acl_policy.terraform-storage.name
  ]
  local = true
}
