
variable "terraform_app_role_secret_ttl" {
  type        = number
  default     = 360000
  description = "TTL in seconds for any Secret ID for the Terraform AppRole"
}

variable "secrets_path_prefix" {
  type        = string
  default     = "tf-secrets"
  description = "Path to prefix all secrets created and managed by Terraform with"
}
