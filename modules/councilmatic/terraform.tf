// passed in to the module via a "providers" block:
provider "aws" {
  alias = "cloudfront"
}

variable "security_group_name" {}
variable "key_pair_id" {}
variable "zone_id" {}

resource "aws_instance" "councilmatic" {
  ami = "ami-0afae182eed9d2b46"
  instance_type = "t2.small"
  associate_public_ip_address = true
  security_groups = [var.security_group_name]
  key_name = var.key_pair_id

  tags = {
    Name = "Councilmatic"
  }

  provisioner "remote-exec" {
    connection {
      type = "ssh"
      host = self.public_ip
      user = "ubuntu"
      // TODO: Pass this in as a variable with 1password
      private_key = file("~/.ssh/id_rsa_openoakland")
    }
  }
}

resource "aws_route53_record" "councilmatic" {
  zone_id = var.zone_id
  name = "councilmatic"
  type = "A"
  ttl = 60
  records = [aws_instance.councilmatic.public_ip]
}

resource "aws_acm_certificate" "cert" {
  provider          = aws.cloudfront
  domain_name       = "oaklandcouncil.net"
  validation_method = "DNS"
}

resource "aws_acm_certificate_validation" "cert" {
  provider                = aws.cloudfront
  certificate_arn         = aws_acm_certificate.cert.arn
  # TODO: Add in `validation_record_fqdns` when we get Namecheap wired up in here.
}

resource "aws_cloudfront_distribution" "councilmatic" {
  provider = aws.cloudfront
  enabled = true

  aliases = ["oaklandcouncil.net"]
  origin {
    origin_id = "oaklandcouncil.net"
    domain_name = aws_instance.councilmatic.public_dns
    custom_origin_config {
      http_port = 80
      https_port = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols = ["TLSv1", "TLSv1.1", "TLSv1.2"]
    }
  }

  default_cache_behavior {
    allowed_methods = ["GET", "HEAD", "POST", "PATCH", "PUT", "DELETE", "OPTIONS"]
    cached_methods = ["GET", "HEAD"]
    target_origin_id = "oaklandcouncil.net"
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      headers = ["*"]
      query_string = true
      cookies {
        forward = "all"
      }
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn = aws_acm_certificate_validation.cert.certificate_arn
    ssl_support_method = "sni-only"
  }
}

# TODO: use Namecheap terraform plugin for this stuff (or move domains to Route53)
# TODO: create DNS validation record automatically
# TODO: add aws_acm_certificate_validation back in here

output "validation_record" {
  value = <<MSG
You will need to create a DNS validation record for the TLS certificate:

${aws_acm_certificate.cert.domain_validation_options.0.resource_record_name}
${aws_acm_certificate.cert.domain_validation_options.0.resource_record_type}
${aws_acm_certificate.cert.domain_validation_options.0.resource_record_value}
MSG
}
