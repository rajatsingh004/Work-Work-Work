variable "name" {
  type        = string
  description = "Distribution name/comment."
}
variable "s3_bucket_id" {
  type        = string
  default     = null
  description = "Private S3 bucket ID when using an S3 origin."
}
variable "s3_bucket_arn" {
  type        = string
  default     = null
  description = "Private S3 bucket ARN used for the OAC policy."
}
variable "s3_bucket_domain_name" {
  type        = string
  default     = null
  description = "Regional S3 bucket domain name."
}
variable "alb_domain_name" {
  type        = string
  default     = null
  description = "ALB DNS name when using an ALB origin."
}
variable "default_origin_id" {
  type        = string
  description = "Either s3-origin or alb-origin."
}
variable "default_cache_policy_id" {
  type        = string
  description = "Managed or custom cache policy ID."
}
variable "default_origin_request_policy_id" {
  type        = string
  default     = null
  description = "Optional origin-request policy ID."
}
variable "ordered_behaviors" {
  type = list(object({
    path_pattern              = string
    origin_id                 = string
    allowed_methods           = list(string)
    cached_methods            = list(string)
    cache_policy_id           = string
    origin_request_policy_id  = optional(string)
  }))
  default     = []
  description = "Ordered path behaviors. Keep cache-key forwarding explicit."
}
variable "aliases" {
  type        = list(string)
  default     = []
  description = "Alternate domain names, such as app.example.com."
}
variable "viewer_certificate_arn" {
  type        = string
  description = "ACM certificate ARN for CloudFront viewer TLS (issued in us-east-1)."
}
variable "default_root_object" {
  type        = string
  default     = "index.html"
  description = "Default object for the distribution."
}
variable "enabled" {
  type        = bool
  default     = true
  description = "Whether the distribution is enabled."
}
variable "price_class" {
  type        = string
  default     = "PriceClass_100"
  description = "CloudFront price class."
}
variable "geo_restriction_type" {
  type        = string
  default     = "none"
  description = "none, whitelist, or blacklist."
}
variable "geo_restriction_locations" {
  type        = list(string)
  default     = []
  description = "Country codes for geo restriction."
}
variable "web_acl_arn" {
  type        = string
  default     = null
  description = "Optional WAFv2 web ACL ARN."
}
variable "tags" {
  type        = map(string)
  default     = {}
  description = "Distribution tags."
}
