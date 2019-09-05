
resource "vault_policy" "admin" {
  name = "admin"

  policy = <<EOT
# Manage auth methods broadly across Vault
path "auth/*"
{
  capabilities = ["create", "read", "update", "delete", "sudo"]
}

path "auth/"
{
  capabilities = ["list"]
}

# Read auth methods
path "sys/auth"
{
  capabilities = ["read"]
}

# Create, read, update, and delete auth methods
path "sys/auth/*"
{
  capabilities = ["create",  "read", "update", "delete", "sudo"]
}

# List existing policies
path "sys/policy"
{
  capabilities = ["read"]
}

# Create and manage ACL policies
path "sys/policies/acl/*"
{
  capabilities = ["create", "read", "update", "delete"]
}

path "sys/policies/acl/"
{
  capabilities = ["list"]
}

# path "sys/policy/"
# {
#   capabilities = ["list"]
# }

# # Create and manage ACL policies
# path "sys/policy/*"
# {
#   capabilities = ["create", "read", "update", "delete", "sudo"]
# }

# /sys/policies/acl

# Manage secret engines
path "sys/mounts/*"
{
  capabilities = ["create", "read", "update", "delete", "sudo"]
}

# List existing secret engines.
path "sys/mounts"
{
  capabilities = ["read"]
}

path "sys/mounts/"
{
  capabilities = ["list"]
}

# Read health checks
path "sys/health"
{
  capabilities = ["read", "sudo"]
}

# So Terraform can generate tokens
# https://github.com/hashicorp/terraform/issues/16457
path "auth/token/create" {
  capabilities = ["create", "read", "update"]
}

path "auth/token/"
{
  capabilities = ["list"]
}
EOT
}

# resource "vault_identity_entity" "test" {
#   name      = "tester1"
#   policies  = ["admin"]
#   metadata  = {
#     source = "terraform"
#   }
# }

resource "vault_token" "admin" {
  display_name = "terraform-admin"

  policies = ["admin"]

  renewable = true
  ttl = "720h"

}

// how to revoke root cert?

// https://www.vaultproject.io/api/auth/token/index.html#revoke-a-token-self-

// https://learn.hashicorp.com/vault/security/iam-approle-trusted-entities
// https://www.hashicorp.com/resources/delivering-secret-zero-vault-approle-terraform-chef
// https://github.com/hashicorp/terraform/issues/12687#issuecomment-306445901
