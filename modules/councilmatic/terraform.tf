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

    inline = [
      "sudo useradd --create-home --shell /bin/bash tdooner",
      "sudo -u tdooner mkdir -p ~tdooner/.ssh",
      "sudo -u tdooner bash -c 'echo \"${file("ssh-keys/tom.pub")}\" > ~tdooner/.ssh/authorized_keys'",
      "sudo -u tdooner chmod 600 ~tdooner/.ssh/authorized_keys",
      "sudo usermod -aG sudo tdooner && sudo passwd -de tdooner",
      "echo 'tdooner ALL=(ALL) NOPASSWD:ALL' | sudo tee '/etc/sudoers.d/tdooner' && sudo chmod 440 /etc/sudoers.d/tdooner",

      "sudo useradd --create-home --shell /bin/bash howard",
      "sudo -u howard mkdir -p ~howard/.ssh",
      "sudo -u howard bash -c 'echo \"${file("ssh-keys/howard.pub")}\" > ~howard/.ssh/authorized_keys'",
      "sudo -u howard chmod 600 ~howard/.ssh/authorized_keys",
      "sudo usermod -aG sudo howard && sudo passwd -de howard",
      "echo 'howard ALL=(ALL) NOPASSWD:ALL' | sudo tee '/etc/sudoers.d/howard' && sudo chmod 440 /etc/sudoers.d/howard"
    ]
  }
}

resource "aws_route53_record" "councilmatic" {
  zone_id = "${var.zone_id}"
  name = "councilmatic"
  type = "A"
  ttl = 60
  records = ["${aws_instance.councilmatic.public_ip}"]
}
