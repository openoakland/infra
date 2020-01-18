output "aws_access_key_id" {
  value     = module.ci_user.access_key_id
  sensitive = true
}

output "aws_secret_access_key" {
  value     = module.ci_user.secret_access_key
  sensitive = true
}
