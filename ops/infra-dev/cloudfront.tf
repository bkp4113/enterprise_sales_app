resource "aws_cloudfront_distribution" "alb_distribution" {
    origin {
        domain_name = aws_lb.enterprise_alb.dns_name
        origin_id   = "enterprise-alb-origin"

        custom_origin_config {
            http_port                = 80
            https_port               = 443
            origin_protocol_policy   = "http-only"
            origin_ssl_protocols     = ["TLSv1.2"]
            origin_keepalive_timeout = 5
            origin_read_timeout      = 30
        }
    }

    enabled             = true
    is_ipv6_enabled     = true
    comment             = "CloudFront Distribution for ALB"
    default_root_object = "index.html"

    default_cache_behavior {
        allowed_methods  = ["GET", "OPTIONS"]
        cached_methods   = ["GET", "HEAD"]
        target_origin_id = "enterprise-alb-origin"

        forwarded_values {
            query_string = false

            cookies {
                forward = "none"
            }

            headers = ["Host", "Origin", "Authorization"]  # Include necessary headers for ALB
        }

        viewer_protocol_policy = "redirect-to-https"  # Ensures CloudFront serves traffic over HTTPS
        min_ttl                = 0
        default_ttl            = 3600
        max_ttl                = 86400
    }

    ordered_cache_behavior {
        path_pattern     = "/api/*"
        allowed_methods  = ["GET", "OPTIONS"]
        cached_methods   = ["GET", "OPTIONS"]
        target_origin_id = "enterprise-alb-origin"

        forwarded_values {
            query_string = true
            headers      = ["Origin", "Authorization"]

            cookies {
                forward = "none"
            }
        }

        min_ttl                = 0
        default_ttl            = 60
        max_ttl                = 180
        compress               = true
        viewer_protocol_policy = "redirect-to-https"
    }

    price_class = "PriceClass_200"

    restrictions {
        geo_restriction {
            restriction_type = "whitelist"
            locations        = ["US"]
        }
    }

    viewer_certificate {
        cloudfront_default_certificate = true
    }
}
