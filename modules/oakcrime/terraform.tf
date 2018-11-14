variable "security_group_name" {}
variable "key_pair_id" {}
variable "zone_id" {}

resource "aws_instance" "oakcrime" {
  ami = "ami-ecc63a94"
  instance_type = "t2.medium"
  associate_public_ip_address = true
  security_groups = ["${var.security_group_name}"]
  key_name = "${var.key_pair_id}"

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
      "echo 'tdooner ALL=(ALL) NOPASSWD:ALL' | sudo tee '/etc/sudoers.d/tdooner' && sudo chmod 440 /etc/sudoers.d/tdooner",

      "sudo useradd --create-home --shell /bin/bash rik",
      "sudo -u rik mkdir -p ~rik/.ssh",
      "sudo -u rik bash -c 'echo \"${file("ssh-keys/rik.pub")}\" > ~rik/.ssh/authorized_keys'",
      "sudo -u rik chmod 600 ~rik/.ssh/authorized_keys",
      "sudo usermod -aG sudo rik && sudo passwd -de rik",
      "echo 'rik ALL=(ALL) NOPASSWD:ALL' | sudo tee '/etc/sudoers.d/rik' && sudo chmod 440 /etc/sudoers.d/rik"
    ]
  }
}

resource "aws_route53_record" "oakcrime" {
  zone_id = "${var.zone_id}"
  name = "oakcrime"
  type = "A"
  ttl = 60
  records = ["${aws_instance.oakcrime.public_ip}"]
}
