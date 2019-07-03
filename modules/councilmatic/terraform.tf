variable "security_group_name" {}
variable "key_pair_id" {}
variable "zone_id" {}

resource "aws_instance" "councilmatic" {
  ami = "ami-0afae182eed9d2b46"
  instance_type = "t2.small"
  associate_public_ip_address = true
  security_groups = ["${var.security_group_name}"]
  key_name = "${var.key_pair_id}"

  tags {
    Name = "Councilmatic"
  }

  provisioner "remote-exec" {
    connection {
      type = "ssh"
      user = "ubuntu"
      // TODO: Pass this in as a variable with 1password
      private_key = "${file("~/.ssh/id_rsa_openoakland")}"
    }
  }
}

resource "aws_route53_record" "councilmatic" {
  zone_id = "${var.zone_id}"
  name = "councilmatic"
  type = "A"
  ttl = 60
  records = ["${aws_instance.councilmatic.public_ip}"]
}
