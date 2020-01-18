variable "oakcrime_prod_db_password" {
  description = "db_password for the production app."
}

variable "oakcrime_prod_django_secret_key" {
  description = "django_secret_key for the production app."
}

variable "oakcrime_prod_socrata_key" {
  description = "socrata_key for the production app."
}

variable "oakcrime_prod_google_maps_api_key" {
  description = "Google Maps API key for the production app."
}

variable "oakcrime_prod_box_enterprise_id" {
  description = "BOX_ENTERPRISE_ID for the production app."
}

variable "oakcrime_prod_box_client_id" {
  description = "BOX_CLIENT_ID for the production app."
}

variable "oakcrime_prod_box_client_secret" {
  description = "BOX_CLIENT_SECRET for the production app."
}

variable "oakcrime_prod_box_public_key_id" {
  description = "BOX_PUBLIC_KEY_ID for the production app."
}

variable "oakcrime_prod_box_rsa_key" {
  description = "BOX_RSA_KEY for the production app."
}

variable "oakcrime_prod_box_pass_phrase" {
  description = "BOX_PASS_PHRASE for the production app."
}

module "oakcrime" {
  source              = "./modules/oakcrime"
  security_group_name = aws_security_group.ssh_and_web.name
  key_pair_id         = aws_key_pair.openoakland.id
  zone_id             = data.aws_route53_zone.openoakland.id

  # Beanstalk apps
  dns_zone                 = data.aws_route53_zone.openoakland.name
  prod_box_client_id       = var.oakcrime_prod_box_client_id
  prod_box_client_secret   = var.oakcrime_prod_box_client_secret
  prod_box_enterprise_id   = var.oakcrime_prod_box_enterprise_id
  prod_box_pass_phrase     = var.oakcrime_prod_box_pass_phrase
  prod_box_public_key_id   = var.oakcrime_prod_box_public_key_id
  prod_box_rsa_key         = var.oakcrime_prod_box_rsa_key
  prod_db_password         = var.oakcrime_prod_db_password
  prod_django_secret_key   = var.oakcrime_prod_django_secret_key
  prod_google_maps_api_key = var.oakcrime_prod_google_maps_api_key
  prod_socrata_key         = var.oakcrime_prod_socrata_key
}

output "oakcrime_ci_aws_access_key_id" {
  value     = module.oakcrime.ci_aws_access_key_id
  sensitive = true
}

output "oakcrime_ci_aws_secret_access_key" {
  value     = module.oakcrime.ci_aws_secret_access_key
  sensitive = true
}
