variable "json_secret" {
  type = string
  description = "KV pairs of secrets in JSON format."
  default = <<-EOT
{
  "server":  "asd"
}
EOT
}

# variable "vault_token" {
#   type = string
#   description = "Vault token to use"
# }
