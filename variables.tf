variable "zone" {
  description = "Route53 zone name"
  type        = string
}

variable "target_url" {
  description = "URL to redirect to"
  type        = string
}

variable "cloudfront_forward_query_string" {
  description = "Toggle forwarding of query strings for CloudFront"
  type        = bool
  default     = false
}
