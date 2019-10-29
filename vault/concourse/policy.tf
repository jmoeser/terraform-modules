resource "vault_policy" "concourse-ro" {
  name = "concourse-ro"

  policy = <<EOT
path "${var.secrets_path_prefix}/concourse/*" {
  policy = "read"
}
EOT
}

# child policies must be subset of parent
# resource "vault_token" "concourse-secret-provisioner" {
#   display_name = "concourse-secret-provisioner"

#   policies = ["concourse-rw"]

#   renewable = true
#   ttl       = "720h"

# }


# Need?
# path "auth/approle/login" {
#   capabilities = [ "create", "read" ]
# }
