module "councilmatic" {
  source = "./modules/councilmatic"
  security_group_name = "${aws_security_group.ssh_and_web.name}"
  key_pair_id = "${aws_key_pair.openoakland.id}"
  zone_id = "${data.aws_route53_zone.openoakland.id}"
}
