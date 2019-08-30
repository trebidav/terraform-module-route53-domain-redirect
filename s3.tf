resource "random_string" "hash" {
  length  = 16
  special = false
}

resource "aws_s3_bucket" "redirect_bucket" {
  bucket = "redirect-${var.zone}-${lower(random_string.hash.result)}"
  acl    = "public-read"

  website {
    redirect_all_requests_to = "${var.target_url}"
  }
}
