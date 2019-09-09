
resource "vault_pki_secret_backend_intermediate_cert_request" "intermediate" {
  backend = vault_mount.pki.path

  type        = "internal"
  common_name = "app.test.test"
  key_type    = "ec"
  key_bits    = 224

  depends_on = [
    vault_mount.pki
  ]
}

resource "vault_pki_secret_backend_root_sign_intermediate" "intermediate" {
  backend = vault_mount.pki-root.path

  csr                  = vault_pki_secret_backend_intermediate_cert_request.intermediate.csr
  common_name          = "Intermediate CA"
  exclude_cn_from_sans = true
  ou                   = "My OU"
  organization         = "My organization"
}

resource "vault_pki_secret_backend_intermediate_set_signed" "intermediate" {
  backend = vault_mount.pki.path

  certificate = vault_pki_secret_backend_root_sign_intermediate.intermediate.certificate
}

resource "vault_pki_secret_backend_role" "role" {
  backend = vault_mount.pki.path
  name    = "my_role"
}
