resource "vault_pki_secret_backend_cert" "test" {
  backend = vault_mount.pki.path

  name = vault_pki_secret_backend_role.role.name

  common_name = "app.test.test"
}
