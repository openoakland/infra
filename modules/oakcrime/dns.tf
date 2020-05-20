resource "aws_route53_zone" "oakcrime" {
  name = "oakcrime.org"
}

resource "aws_acm_certificate" "cert" {
  provider          = aws.cloudfront
  domain_name       = "oakcrime.org"
  validation_method = "DNS"
  subject_alternative_names = ["www.oakcrime.org"]
}

resource "aws_route53_record" "cert_validation" {
  name    = aws_acm_certificate.cert.domain_validation_options.0.resource_record_name
  type    = aws_acm_certificate.cert.domain_validation_options.0.resource_record_type
  zone_id = aws_route53_zone.oakcrime.zone_id
  records = [aws_acm_certificate.cert.domain_validation_options.0.resource_record_value]
  ttl     = 60
}

resource "aws_route53_record" "cert_validation_www" {
  name    = aws_acm_certificate.cert.domain_validation_options.1.resource_record_name
  type    = aws_acm_certificate.cert.domain_validation_options.1.resource_record_type
  zone_id = aws_route53_zone.oakcrime.zone_id
  records = [aws_acm_certificate.cert.domain_validation_options.1.resource_record_value]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "cert" {
  provider                = aws.cloudfront
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [
    aws_route53_record.cert_validation.fqdn, aws_route53_record.cert_validation_www.fqdn
  ]
}

resource "aws_cloudfront_distribution" "oakcrime" {
  provider = aws.cloudfront
  enabled = true

  aliases = ["oakcrime.org", "www.oakcrime.org"]
  origin {
    origin_id = "oakcrime.org"
    domain_name = module.env_web_production.fqdn
    custom_origin_config {
      http_port = 80
      https_port = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols = ["TLSv1", "TLSv1.1", "TLSv1.2"]
    }
  }

  default_cache_behavior {
    allowed_methods = ["GET", "HEAD", "POST", "PATCH", "PUT", "DELETE", "OPTIONS"]
    cached_methods = ["GET", "HEAD"]
    target_origin_id = "oakcrime.org"
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

resource "aws_route53_record" "oakcrime_org" {
  name    = "oakcrime.org"
  type    = "A"
  zone_id = aws_route53_zone.oakcrime.zone_id

  alias {
    name = aws_cloudfront_distribution.oakcrime.domain_name
    zone_id = aws_cloudfront_distribution.oakcrime.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "www_oakcrime_org" {
  name    = "www.oakcrime.org"
  type    = "CNAME"
  zone_id = aws_route53_zone.oakcrime.zone_id
  records = [aws_cloudfront_distribution.oakcrime.domain_name]
  ttl     = 60
}

