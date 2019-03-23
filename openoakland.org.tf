module "openoakland_org" {
  source = "./modules/openoakland.org"
}

output "openoakland_org_aws_access_key_id" {
  value = "${module.openoakland_org.aws_access_key_id}"
}

output "openoakland_org_aws_secret_access_key" {
  value = "${module.openoakland_org.aws_secret_access_key}"
}
