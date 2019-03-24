provider "aws" {
  alias = "main"
}

provider "aws" {
  alias = "cloudfront"
}

module "site" {
  source = "github.com/openoakland/terraform-modules//s3_cloudfront_website?ref=s3-cloudfront-website"
  host   = "beta"
  zone   = "aws.openoakland.org"

  providers = {
    aws.main       = "aws.main"
    aws.cloudfront = "aws.cloudfront"
  }
}

module "ci_user" {
  source = "github.com/openoakland/terraform-modules//s3_deploy_user?ref=s3-cloudfront-website"

  username      = "ci-openoakland-org"
  s3_bucket_arn = "${module.site.s3_bucket_arn}"
}
