provider "aws" {
  shared_credentials_file = "/dev/null" # require environment variables
  region = "us-west-2"
}

data "aws_route53_zone" "openoakland" {
  name = "aws.openoakland.org"
}

resource "aws_security_group" "ssh_and_web" {
  name = "ssh_and_web"
  description = "Allow SSH and Web connections"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "openoakland" {
  key_name = "OpenOakland"
  public_key = "${file("ssh-keys/openoakland.pub")}"
}

module "oakcrime" {
  source = "./modules/oakcrime"
  security_group_name = "${aws_security_group.ssh_and_web.name}"
  key_pair_id = "${aws_key_pair.openoakland.id}"
  zone_id = "${data.aws_route53_zone.openoakland.id}"
}

module "councilmatic" {
  source = "./modules/councilmatic"
  security_group_name = "${aws_security_group.ssh_and_web.name}"
  key_pair_id = "${aws_key_pair.openoakland.id}"
  zone_id = "${data.aws_route53_zone.openoakland.id}"
}
