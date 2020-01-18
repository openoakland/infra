variable "security_group_name" {}
variable "key_pair_id" {}
variable "zone_id" {}

variable "prod_box_enterprise_id" {
  description = "Box Enterprise ID for Patrol log fetching."
  type = string
}

variable "prod_box_client_id" {
  description = "Box Client ID for Patrol log fetching."
  type = string
}

variable "prod_box_client_secret" {
  description = "Box Client secret for Patrol log fetching."
  type = string
}

variable "prod_box_public_key_id" {
  description = "Box public key ID for Patrol log fetching."
  type = string
}

variable "prod_box_rsa_key" {
  description = "Box RSA key for Patrol log fetching."
  type = string
}

variable "prod_box_pass_phrase" {
  description = "Box RSA key passphrase for Patrol log fetching."
  type = string
}

# pwgen -s -N 1 20
variable "prod_db_password" {
  description = "Production password for the RDS database."
  type        = string
}

# pwgen -s -N 1 50
variable "prod_django_secret_key" {
  description = "Production SECRET_KEY setting to provide the Django application."
  type        = string
}

variable "prod_google_maps_api_key" {
  description = "Key for Google Maps API used for geocoding"
  type        = string
}

variable "prod_socrata_key" {
  description = "Socrata API key for accessing data.oaklandnet.com"
  type        = string
}

variable "dns_zone" {
  description = "DNS zone for the Beanstalk applications"
  default     = "aws.openoakland.org"
}
