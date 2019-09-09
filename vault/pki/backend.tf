
resource "vault_mount" "pki" {
  path        = "pki"
  type        = "pki"
  description = "Vault TLS Authority"
  # 90 days
  default_lease_ttl_seconds = 7776000
  # 1 year
  max_lease_ttl_seconds = 31557600
}

resource "vault_mount" "pki-root" {
  path        = "pki-root"
  type        = "pki"
  description = "Vault Root CA Authority"
  # 90 days
  default_lease_ttl_seconds = 7776000
  # 1 year
  max_lease_ttl_seconds = 31557600
}

resource "vault_pki_secret_backend_config_urls" "config_urls" {
  backend                 = vault_mount.pki-root.path
  issuing_certificates    = ["http://127.0.0.1:8200/v1/pki/ca"]
  crl_distribution_points = ["http://127.0.0.1:8200/v1/pki/crl"]
}
