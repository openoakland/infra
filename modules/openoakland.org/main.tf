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
  source = "github.com/adborden/sites//modules/site?ref=adborden-patch-1"
  host   = "beta"
  zone   = "aws.openoakland.org"
}

resource "aws_iam_user" "ci" {
  name = "ci-openoakland-org"
}

resource "aws_iam_access_key" "ci" {
  user = "${aws_iam_user.ci.name}"
}

resource "aws_iam_user_policy" "ci" {
  name = "ci-openoakland-org-deploy"
  user = "${aws_iam_user.ci.name}"

  # TODO this should be specific to the s3 bucket created
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:ListBucket",
                "s3:DeleteObject"
            ],
            "Resource": [
              "arn:aws:s3:::beta.aws.openoakland.org",
              "arn:aws:s3:::beta.aws.openoakland.org/*"
            ]
        }
    ]
}
EOF
}

output "aws_access_key_id" {
  value = "${aws_iam_access_key.ci.id}"
}

output "aws_secret_access_key" {
  value = "${aws_iam_access_key.ci.secret}"
}
