provider "vault" {
  version = "~> 2.5"
  auth_login {
    path = "auth/approle/login"
    parameters = {
      role_id   = var.role_id
      secret_id = var.secret_id
    }
  }
}

terraform {
  required_version = ">= 0.12"
}
