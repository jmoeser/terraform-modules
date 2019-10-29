resource "vault_mount" "concourse" {
  path = "${var.secrets_path_prefix}/concourse"
  # Concourse needs v1 - https://concourse-ci.org/vault-credential-manager.html
  # type        = "kv-v2"
  type        = "kv"
  description = "Secrets for Concourse CI"
  options = {
    version = "1"
  }
}

resource "vault_generic_secret" "concourse" {
  path = "${var.secrets_path_prefix}/concourse/test"

  data_json = var.json_secret

  depends_on = [vault_mount.concourse]
}

// https://github.com/hashicorp/terraform/issues/16628#issuecomment-510263706
// https://www.hashicorp.com/resources/best-practices-production-hardened-vault
