provider "aws" {
  shared_credentials_file = "/dev/null" # require environment variables
  region = "us-west-2"
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
}

resource "aws_key_pair" "rik" {
  key_name = "Rik Belew"
  public_key = "${file("ssh-keys/rik.pub")}"
}

resource "aws_key_pair" "tom" {
  key_name = "Tom Dooner"
  public_key = "${file("ssh-keys/tom.pub")}"
}

resource "aws_instance" "oakcrime" {
  ami = "ami-ecc63a94"
  instance_type = "t2.medium"
  associate_public_ip_address = true
  vpc_security_group_ids = ["${aws_security_group.ssh_and_web.id}"]
  key_name = "${aws_key_pair.rik.id}"

  tags {
    Name = "OakCrime.org"
  }

  provisioner "remote-exec" {
    inline = [
      "useradd tdooner",
      "useradd rik"
    ]
  }
}
