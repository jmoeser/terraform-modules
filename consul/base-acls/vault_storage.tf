resource "consul_acl_policy" "vault-storage" {
  name = "vault-storage"
  # Rules as per
  # https://www.vaultproject.io/docs/configuration/storage/consul.html
  rules = <<-RULE
    key_prefix "vault/" {
      policy = "write"
    },
    node_prefix "" {
      policy = "write"
    },
    service "vault" {
      policy = "write"
    },
    agent_prefix "" {
      policy = "write"
    },
    session_prefix "" {
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
