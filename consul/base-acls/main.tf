provider "consul" {
  version        = "~> 2.5"
  insecure_https = var.insecure_https
  scheme         = "https"
}

terraform {
  backend "consul" {}
}

// https://blog.codeship.com/terraform-remote-state-with-consul-backend/
