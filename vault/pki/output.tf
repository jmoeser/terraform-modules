output "test_cert_key" {
  value = vault_pki_secret_backend_cert.test.certificate
  sensitive = true
}

output "test_cert" {
  value = vault_pki_secret_backend_cert.test.private_key
  sensitive = true
}
