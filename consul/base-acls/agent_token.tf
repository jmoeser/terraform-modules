resource "consul_acl_policy" "agent" {
  name  = "agent"
  rules = <<-RULE
    node_prefix "" {
      policy = "write"
    }
    RULE
}

resource "consul_acl_token" "agent" {
  description = "Token for Consul Agents"
  policies = [
    consul_acl_policy.agent.name
  ]
  local = true
}
