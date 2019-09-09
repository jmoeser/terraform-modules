# vault write auth/approle/role/concourse policies=concourse period=1h

resource "vault_auth_backend" "approle" {
  type = "approle"
}

resource "vault_approle_auth_backend_role" "concourse" {
  backend        = vault_auth_backend.approle.path
  role_name      = "concourse"
  token_policies = ["concourse"]
  secret_id_ttl  = 3600
}

resource "vault_approle_auth_backend_role_secret_id" "concourse" {
  backend   = vault_auth_backend.approle.path
  role_name = vault_approle_auth_backend_role.concourse.role_name

  metadata = <<EOT
{
  "source": "terraform"
}
EOT
}


// https://github.com/concourse/concourse/issues/1534
