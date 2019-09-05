resource "vault_policy" "concourse-ro" {
  name = "concourse-ro"

  policy = <<EOT
path "concourse/*" {
  policy = "read"
}
EOT
}

# resource "vault_policy" "concourse-rw" {
#   name = "concourse-rw"

#   policy = <<EOT
# path "concourse/*" {
#   capabilities = ["create", "read", "update", "delete", "list"]
# }
# EOT
# }

resource "vault_token" "concourse-secret-provisioner" {
  display_name = "concourse-secret-provisioner"

  policies = ["concourse-rw"]

  renewable = true
  ttl = "720h"

}


# Need?
# path "auth/approle/login" {
#   capabilities = [ "create", "read" ]
# }
