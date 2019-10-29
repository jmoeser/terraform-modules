resource "vault_auth_backend" "approle" {
  type = "approle"
}

resource "vault_approle_auth_backend_role" "terraform" {
  backend        = vault_auth_backend.approle.path
  role_name      = "terraform"
  token_policies = ["provisioner"]
  secret_id_ttl  = var.terraform_app_role_secret_ttl
}

resource "vault_approle_auth_backend_role_secret_id" "terraform" {
  backend   = vault_auth_backend.approle.path
  role_name = vault_approle_auth_backend_role.terraform.role_name

  metadata = <<EOT
{
  "source": "terraform"
}
EOT
}
