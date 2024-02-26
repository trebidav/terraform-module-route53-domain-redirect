resource "random_string" "hash" {
  length  = 16
  special = false
}

resource "aws_s3_bucket" "redirect_bucket" {
  bucket = "redirect-${var.zone}-${lower(random_string.hash.result)}"
}

resource "aws_s3_bucket_ownership_controls" "redirect_bucket" {
  bucket = aws_s3_bucket.redirect_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "redirect_bucket" {
  bucket = aws_s3_bucket.redirect_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "redirect_bucket" {
  depends_on = [
    aws_s3_bucket_ownership_controls.redirect_bucket,
    aws_s3_bucket_public_access_block.redirect_bucket,
  ]

  bucket = aws_s3_bucket.redirect_bucket.id
  acl    = "public-read"
}

resource "aws_s3_bucket_website_configuration" "redirect_bucket" {
  bucket = aws_s3_bucket.redirect_bucket.id

  redirect_all_requests_to {
    host_name = var.target_url
    protocol = "https"
  }
}