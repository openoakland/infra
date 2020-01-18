provider "aws" {
  alias = "cloudfront"
}

module "site" {
  source = "github.com/openoakland/terraform-modules//s3_cloudfront_website"
  host   = "beta"
  zone   = "aws.openoakland.org"
  aliases = ["openoakland.org"]

  providers = {
    aws.main       = aws
    aws.cloudfront = aws.cloudfront
  }
}

module "ci_user" {
  source = "github.com/openoakland/terraform-modules//s3_deploy_user"

  username      = "ci-openoakland-org"
  s3_bucket_arn = module.site.s3_bucket_arn
}
