variable "security_group_name" {}
variable "key_pair_id" {}
variable "zone_id" {}

variable "db_username" {
  description = "Username for the RDS database."
  default     = "oakcrime"
}

variable "db_password" {
  description = "Password for the RDS database."
  type        = "string"
}

variable "django_secret_key" {
  description = "SECRET_KEY setting to provide the Django application."
  type        = "string"
}

variable "dns_zone" {
  description = "DNS zone for the applications"
  default     = "oakcrime-eb2.aws.openoakland.org"
}

variable "app_name" {
  description = "Slugified name of the application instance."
  default     = "oakcrime"
}
