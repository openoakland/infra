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

resource "aws_instance" "oakcrime" {
  ami = "ami-ecc63a94"
  instance_type = "t2.medium"
  associate_public_ip_address = true
  vpc_security_group_ids = ["${aws_security_group.ssh_and_web.id}"]
  key_name = "${aws_key_pair.openoakland.id}"

  tags {
    Name = "OakCrime.org"
  }

  provisioner "remote-exec" {
    connection {
      type = "ssh"
      user = "ubuntu"
      // TODO: Pass this in as a variable with 1password
      private_key = "${file("~/.ssh/id_rsa_openoakland")}"
    }

    inline = [
      "sudo useradd --create-home --shell /bin/bash tdooner",
      "sudo -u tdooner mkdir -p ~tdooner/.ssh",
      "sudo -u tdooner bash -c 'echo \"${file("ssh-keys/tom.pub")}\" > ~tdooner/.ssh/authorized_keys'",
      "sudo -u tdooner chmod 600 ~tdooner/.ssh/authorized_keys",
      "sudo usermod -aG sudo tdooner && sudo passwd -de tdooner",

      "sudo useradd --create-home --shell /bin/bash rik",
      "sudo -u rik mkdir -p ~rik/.ssh",
      "sudo -u rik bash -c 'echo \"${file("ssh-keys/rik.pub")}\" > ~rik/.ssh/authorized_keys'",
      "sudo -u rik chmod 600 ~rik/.ssh/authorized_keys",
      "sudo usermod -aG sudo rik && sudo passwd -de rik"
    ]
  }
}

resource "aws_route53_record" "oakcrime" {
  zone_id = "${data.aws_route53_zone.openoakland.id}"
  name = "oakcrime"
  type = "A"
  ttl = 60
  records = ["${aws_instance.oakcrime.public_ip}"]
}
