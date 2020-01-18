provider "aws" {
  shared_credentials_file = "/dev/null" # require environment variables
  region                  = "us-west-2"
}

provider "aws" {
  shared_credentials_file = "/dev/null" # require environment variables
  region                  = "us-east-1"
  alias                   = "cloudfront"
}

data "aws_route53_zone" "openoakland" {
  name = "aws.openoakland.org"
}

terraform {
  backend "s3" {
    bucket         = "openoakland-infra"
    key            = "terraform.tfstate"
    region         = "us-west-2"
    dynamodb_table = "openoakland_infra"
  }
}

resource "aws_security_group" "ssh_and_web" {
  name        = "ssh_and_web"
  description = "Allow SSH and Web connections"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "openoakland" {
  key_name   = "OpenOakland"
  public_key = file("ssh-keys/openoakland.pub")
}
