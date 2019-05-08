variable "oakcrime_prod_db_password" {
  description = "db_password for the production app."
}

variable "oakcrime_prod_django_secret_key" {
  description = "django_secret_key for the production app."
}

variable "oakcrime_prod_socrata_key" {
  description = "socrata_key for the production app."
}

module "oakcrime" {
  source              = "./modules/oakcrime"
  security_group_name = "${aws_security_group.ssh_and_web.name}"
  key_pair_id         = "${aws_key_pair.openoakland.id}"
  zone_id             = "${data.aws_route53_zone.openoakland.id}"

  # Beanstalk apps
  prod_db_password       = "${var.oakcrime_prod_db_password}"
  prod_django_secret_key = "${var.oakcrime_prod_django_secret_key}"
  prod_socrata_key       = "${var.oakcrime_prod_socrata_key}"
  dns_zone               = "${data.aws_route53_zone.openoakland.name}"
}

output "oakcrime_ci_aws_access_key_id" {
  value     = "${module.oakcrime.ci_aws_access_key_id}"
  sensitive = true
}

output "oakcrime_ci_aws_secret_access_key" {
  value     = "${module.oakcrime.ci_aws_secret_access_key}"
  sensitive = true
}
