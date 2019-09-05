
resource "vault_policy" "provisioner" {
  name = "provisioner"

  policy = <<EOT
# Manage auth methods broadly across Vault
path "auth/*"
{
  capabilities = ["create", "read", "update", "delete"]
}
# , "sudo"

path "auth/"
{
  capabilities = ["list"]
}

# Create, read, update, and delete auth methods
path "sys/auth/*"
{
  capabilities = ["create", "read", "update", "delete"]
}
# , "sudo"

# Read auth methods
path "sys/auth"
{
  capabilities = ["read"]
}

# Create, read, update, and delete auth methods - maybe move this to admin?
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
path "sys/policy/*"
{
  capabilities = ["create", "read", "update", "delete"]
}

path "sys/policy/"
{
  capabilities = ["list"]
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

# So Terraform can generate tokens
# https://github.com/hashicorp/terraform/issues/16457
path "auth/token/create"
{
  capabilities = ["create", "read", "update"]
}
# , "list"

path "auth/token/lookup-self"
{
  capabilities = ["read"]
}

# Manage secret engines
path "sys/mounts"
{
  capabilities = ["read"]
}

path "sys/mounts/*"
{
  capabilities = ["create", "read", "update", "delete"]
}
# , "sudo"

path "sys/mounts/"
{
  capabilities = ["list"]
}

path "auth/approle"
{
  capabilities = ["read"]
}

path "auth/approle/"
{
  capabilities = ["list"]
}

EOT
}

# resource "vault_policy" "provisioner-secret-management" {
#   name = "provisioner-secret-management"

#   policy = <<EOT
# path "concourse/*"
# {
#   capabilities = ["create", "read", "update", "delete", "list"]
# }

# EOT
# }

resource "vault_policy" "concourse-rw" {
  name = "concourse-rw"

  policy = <<EOT
path "concourse/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}
EOT
}


# path "auth/approle/role"
# {
#   capabilities = ["read", "list"]
# }

# path "auth/approle/role/*"
# {
#   capabilities = ["read", "list", "update"]
# }

# path "auth/approle/role/+/secret-id-accessor"
# {
#   capabilities = ["create", "read", "update", "delete", "list"]
# }

# path "auth/approle/role/+/secret-id-accessor/lookup"
# {
#   capabilities = ["create", "read", "update", "delete", "list"]
# }


# List, create, update, and delete key/value secrets
# path "secret/*"
# {
#   capabilities = ["create", "read", "update", "delete", "list"]
# }

# Create and manage ACL policies via API & UI
#path "sys/policy/acl/*"
#{
#  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
#}

resource "vault_token" "provisioner" {
  display_name = "terraform-provisioner"

  policies = [
    "provisioner",
    "concourse-rw"
  ]

  renewable = true
  ttl = "720h"

}

# resource "null_resource" "revoke-root" {
#   provisioner "local-exec" {
#       command = <<EOT
# curl -s -X POST https://api.cloudability.com/v3/vendors/aws/accounts \
#      -H 'Content-Type: application/json' \
#      -u "$${CldAbltyAPIToken:?Missing Cloudability API Token Env Variable}:" \
#      -d '{"vendorAccountId": "${data.aws_caller_identity.current.account_id}", "type": "aws_role" }'
# EOT
# }

# $ curl \
#   --request POST \
#   --header "X-Vault-Token: ..." \
#   --data '{"token": "<token>"}' \
#   https://vault.hashicorp.rocks/v1/auth/token/revoke