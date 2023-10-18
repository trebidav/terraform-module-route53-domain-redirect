resource "random_string" "hash" {
  length  = 16
  special = false
}

resource "aws_s3_bucket" "redirect_bucket" {
  bucket = "redirect-${var.zone}-${lower(random_string.hash.result)}"

  website {
    redirect_all_requests_to = var.target_url
  }
}

data "aws_iam_policy_document" "public_read" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.build_bucket.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
  }

  statement {
    actions   = ["s3:ListBucket"]
    resources = [aws_s3_bucket.build_bucket.arn]

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
  }
}

resource "aws_s3_bucket_policy" "public_read" {
  bucket = aws_s3_bucket.redirect_bucket.id
  policy = data.aws_iam_policy_document.public_read.json
}