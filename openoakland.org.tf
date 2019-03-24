module "openoakland_org" {
  source = "./modules/openoakland.org"

  providers = {
    aws.main = "aws"
    aws.cloudfront = "aws.cloudfront"
  }
}

output "openoakland_org_aws_access_key_id" {
  value     = "${module.openoakland_org.aws_access_key_id}"
  sensitive = true
}

output "openoakland_org_aws_secret_access_key" {
  value     = "${module.openoakland_org.aws_secret_access_key}"
  sensitive = true
}
