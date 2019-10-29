
output "admin_client_token" {
  value     = vault_token.admin.client_token
  sensitive = true
}

output "tf_role_id" {
  value = vault_approle_auth_backend_role.terraform.role_id
}

output "tf_secret_id" {
  value     = vault_approle_auth_backend_role_secret_id.terraform.secret_id
  sensitive = true
}
