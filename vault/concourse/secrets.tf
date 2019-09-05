resource "vault_mount" "concourse" {
  path        = "concourse"
  # Concourse needs v1 - https://concourse-ci.org/vault-credential-manager.html
  # type        = "kv-v2"
  type        = "kv"
  description = "Secrets for Concourse CI"
  options = {
    version = "1"
  }
}

# resource "vault_generic_secret" "concourse" {
#   path = "concourse/test"

#   data_json = var.json_secret

# #   data_json = <<-EOT
# # {
# # %{ for ip in aws_instance.example.*.private_ip ~}
# #   "server":  "${ip}",
# # %{ endfor ~}
# # }
# # EOT

#   depends_on = [vault_mount.concourse]
# }

// https://github.com/hashicorp/terraform/issues/16628#issuecomment-510263706
// https://www.hashicorp.com/resources/best-practices-production-hardened-vault
