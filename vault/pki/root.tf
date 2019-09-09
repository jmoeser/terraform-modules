
resource "vault_pki_secret_backend_root_cert" "test" {
  backend = vault_mount.pki-root.path

  type                 = "internal"
  common_name          = "Root CA"
  ttl                  = "315360000"
  format               = "pem"
  private_key_format   = "der"
  key_type             = "ec"
  key_bits             = 224
  exclude_cn_from_sans = true
  ou                   = "My OU"
  organization         = "My organization"

  depends_on = [
    vault_mount.pki-root
  ]
}
