resource "aws_cloudfront_origin_access_control" "s3" {
  count                             = var.s3_bucket_domain_name == null ? 0 : 1
  name                              = "${var.name}-s3-oac"
  description                       = "Private S3 origin for ${var.name}"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "this" {
  enabled             = var.enabled
  comment             = var.name
  aliases             = var.aliases
  default_root_object = var.default_root_object
  web_acl_id          = var.web_acl_arn
  price_class         = var.price_class
  tags                = var.tags

  dynamic "origin" {
    for_each = var.s3_bucket_domain_name == null ? [] : [var.s3_bucket_domain_name]
    content {
      domain_name              = origin.value
      origin_id                = "s3-origin"
      origin_access_control_id = aws_cloudfront_origin_access_control.s3[0].id
    }
  }

  dynamic "origin" {
    for_each = var.alb_domain_name == null ? [] : [var.alb_domain_name]
    content {
      domain_name = origin.value
      origin_id   = "alb-origin"
      custom_origin_config {
        http_port              = 80
        https_port             = 443
        origin_protocol_policy = "https-only"
        origin_ssl_protocols   = ["TLSv1.2"]
      }
    }
  }

  default_cache_behavior {
    target_origin_id       = var.default_origin_id
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods         = ["GET", "HEAD"]
    cache_policy_id        = var.default_cache_policy_id
    origin_request_policy_id = var.default_origin_request_policy_id
    compress               = true
  }

  dynamic "ordered_cache_behavior" {
    for_each = var.ordered_behaviors
    content {
      path_pattern           = ordered_cache_behavior.value.path_pattern
      target_origin_id       = ordered_cache_behavior.value.origin_id
      viewer_protocol_policy = "redirect-to-https"
      allowed_methods        = ordered_cache_behavior.value.allowed_methods
      cached_methods         = ordered_cache_behavior.value.cached_methods
      cache_policy_id        = ordered_cache_behavior.value.cache_policy_id
      origin_request_policy_id = ordered_cache_behavior.value.origin_request_policy_id
      compress               = true
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = var.geo_restriction_type
      locations        = var.geo_restriction_locations
    }
  }

  viewer_certificate {
    acm_certificate_arn      = var.viewer_certificate_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  lifecycle {
    precondition {
      condition     = var.default_origin_id == "s3-origin" ? var.s3_bucket_domain_name != null : var.alb_domain_name != null
      error_message = "The selected default origin must be configured."
    }
    precondition {
      condition = (
        var.s3_bucket_domain_name == null && var.s3_bucket_id == null && var.s3_bucket_arn == null
        || var.s3_bucket_domain_name != null && var.s3_bucket_id != null && var.s3_bucket_arn != null
      )
      error_message = "For an S3 origin, provide the bucket domain name, ID, and ARN together so the OAC policy can be managed."
    }
  }
}

resource "aws_s3_bucket_policy" "cloudfront_read" {
  count  = var.s3_bucket_id == null ? 0 : 1
  bucket = var.s3_bucket_id
  policy = data.aws_iam_policy_document.cloudfront_read[0].json
}

data "aws_iam_policy_document" "cloudfront_read" {
  count = var.s3_bucket_id == null ? 0 : 1
  statement {
    sid       = "AllowCloudFrontReadOnly"
    actions   = ["s3:GetObject"]
    resources = ["${var.s3_bucket_arn}/*"]
    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }
    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [aws_cloudfront_distribution.this.arn]
    }
  }
}
