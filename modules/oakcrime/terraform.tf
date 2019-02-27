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

#########################
# Beanstalk applications
#########################

module "ci_user" {
  source = "github.com/openoakland/terraform-modules//ci_user?ref=ci-user"

  ci_username = "oakcrime-ci"
}

module "app_oakcrime" {
  source = "github.com/openoakland/terraform-modules//beanstalk_app?ref=postgresdb"

  app_name = "oakcrime"
}

module "db_production" {
  source = "github.com/openoakland/terraform-modules//postgresdb?ref=postgresdb"

  db_name     = "oakcrime"
  db_password = "${var.prod_db_password}"
  db_username = "oakcrime"
  namespace   = "oakcrime-prod"
}

module "env_web_production" {
  source = "github.com/openoakland/terraform-modules//beanstalk_env?ref=postgresdb"

  app_instance = "prod-web"
  app_name     = "oakcrime"
  dns_zone     = "aws.openoakland.org"
  key_pair     = "oakcrime"

  environment_variables = {
    DATABASE_URL = "${module.db_production.postgis_database_url}"
    EMAIL_URL    = "smtp://localhost"
    SECRET_KEY   = "${var.prod_django_secret_key}"
    SERVER_EMAIL = "root@localhost"
  }
}
