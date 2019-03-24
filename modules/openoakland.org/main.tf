# TODO understand where these providers are supposed to live
provider "aws" {
  region = "us-west-2"
  alias  = "main"
}

provider "aws" {
  region = "us-east-1"
  alias  = "cloudfront"
}

module "site" {
  source = "github.com/openoakland/terraform-modules//s3_cloudfront_website?ref=s3-cloudfront-website"
  host   = "beta"
  zone   = "aws.openoakland.org"
}

module "ci_user" {
  source = "github.com/openoakland/terraform-modules//s3_deploy_user?ref=s3-cloudfront-website"

  username      = "ci-openoakland-org"
  s3_bucket_arn = "${module.site.s3_bucket_arn}"
}

output "aws_access_key_id" {
  value = "${module.ci_user.access_key_id}"
}

output "aws_secret_access_key" {
  value = "${module.ci_user.secret_access_key}"
}
