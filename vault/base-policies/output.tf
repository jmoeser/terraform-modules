
output "admin_client_token" {
  value = vault_token.admin.client_token
  sensitive = true
}

output "provisioner_client_token" {
  value = vault_token.provisioner.client_token
  sensitive = true
}
