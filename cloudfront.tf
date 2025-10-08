locals {
  s3_origin_id = "cf-s3-origin"
  # my_domain    = "mydomain.com"
}

# data "aws_acm_certificate" "my_domain" {
#   region   = "us-east-1"
#   domain   = "*.${local.my_domain}"
#   statuses = ["ISSUED"]
# }

resource "aws_cloudfront_origin_access_control" "dg_scoreboard_s3_distribution_oac" {
  name                              = "cf-s3-oac"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "dg_scoreboard_s3_distribution" {
  origin {
    domain_name              = aws_s3_bucket.dg_scoreboard_frontend_bucket.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.dg_scoreboard_s3_distribution_oac.id
    origin_id                = local.s3_origin_id
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "CloudFront Distribution for dg-scoreboard frontend"
  default_root_object = "index.html"

  # aliases = ["mysite.${local.my_domain}", "yoursite.${local.my_domain}"]

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods  = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 86400
    max_ttl                = 86400
  }

  price_class = "PriceClass_100"

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["NO"]
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
  
  # viewer_certificate {
  #   acm_certificate_arn = data.aws_acm_certificate.my_domain.arn
  #   ssl_support_method  = "sni-only"
  # }
}

# Create Route53 records for the CloudFront distribution aliases
# data "aws_route53_zone" "my_domain" {
#   name = local.my_domain
# }

# resource "aws_route53_record" "cloudfront" {
#   for_each = aws_cloudfront_distribution.s3_distribution.aliases
#   zone_id  = data.aws_route53_zone.my_domain.zone_id
#   name     = each.value
#   type     = "A"

#   alias {
#     name                   = aws_cloudfront_distribution.s3_distribution.domain_name
#     zone_id                = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
#     evaluate_target_health = false
#   }
# }