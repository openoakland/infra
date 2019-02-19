variable "security_group_name" {}
variable "key_pair_id" {}
variable "zone_id" {}

# pwgen -s -N 1 20
variable "prod_db_password" {
  description = "Production password for the RDS database."
  type        = "string"
}

# pwgen -s -N 1 50
variable "prod_django_secret_key" {
  description = "Production SECRET_KEY setting to provide the Django application."
  type        = "string"
}

variable "dns_zone" {
  description = "DNS zone for the Beanstalk applications"
  default     = "oakcrime-eb2.aws.openoakland.org"
}

variable "app_name" {
  description = "Slugified name of the application instance."
  default     = "oakcrime"
}
