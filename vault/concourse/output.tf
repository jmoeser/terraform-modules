output "role_id" {
  value = vault_approle_auth_backend_role.concourse.role_id
}

output "secret_id" {
  value     = vault_approle_auth_backend_role_secret_id.concourse.secret_id
  sensitive = true
}

output "concourse_secret_provisioner_token" {
  value     = vault_token.concourse-secret-provisioner.client_token
  sensitive = true
}
