output "namecheap_name_servers" {
  value = join(" ", aws_route53_zone.oakcrime.name_servers)
}

output "ci_aws_access_key_id" {
  value     = "${module.ci_user.access_key_id}"
  sensitive = true
}

output "ci_aws_secret_access_key" {
  value     = "${module.ci_user.secret_access_key}"
  sensitive = true
}
