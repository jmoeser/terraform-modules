resource "consul_acl_policy" "vault-storage" {
  name  = "vault-storage"
  rules = <<-RULE
    key_prefix "vault/" {
      policy = "write"
    }
    RULE
}

resource "consul_acl_token" "vault-storage" {
  description = "Token for Vault's Consul Storage backend"
  policies = [
    consul_acl_policy.vault-storage.name
  ]
  local = true
}
