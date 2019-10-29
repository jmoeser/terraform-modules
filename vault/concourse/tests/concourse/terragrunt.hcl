terraform {
  source = "../..//"
}

inputs = {
  json_secret = <<-EOT
{
  "email_password":  "password",
  "git_token": "password"
}
EOT
}
