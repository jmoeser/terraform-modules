
variable "terraform_app_role_secret_ttl" {
  type        = number
  default     = 360000
  description = "TTL in seconds for any Secret ID for the Terraform AppRole"
}
