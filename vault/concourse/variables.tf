variable "approle_path" {
  type        = string
  default     = "approle"
  description = "Path for the AppRole auth backend the Concourse AppRole will be created under"
}

variable "role_id" {
  type        = string
  description = "KV pairs of secrets in JSON format."
}

variable "secret_id" {
  type        = string
  description = "KV pairs of secrets in JSON format."
}

variable "json_secret" {
  type        = string
  description = "KV pairs of secrets in JSON format."
}
