resource "aws_s3_bucket" "dg_scoreboard_frontend_bucket" {
  bucket = "${var.company_name}-${var.app_name}-${var.environment}-frontend"
}

resource "aws_s3_bucket_website_configuration" "dg_scoreboard_frontend_bucket_website_config" {
  bucket = aws_s3_bucket.dg_scoreboard_frontend_bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }
}

resource "aws_s3_bucket_public_access_block" "dg_scoreboard_frontend_bucket_public_access_block" {
  bucket = aws_s3_bucket.dg_scoreboard_frontend_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "s3_allow_cloudfront_read_access" {
  bucket = aws_s3_bucket.dg_scoreboard_frontend_bucket.id
  policy = data.aws_iam_policy_document.allow_cloudfront_read_bucket_policy.json
  depends_on = [ aws_s3_bucket_public_access_block.dg_scoreboard_frontend_bucket_public_access_block ]
}

data "aws_iam_policy_document" "allow_cloudfront_read_bucket_policy" {
  statement {
    sid    = "AllowCloudFrontServicePrincipalRead"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    actions = [
      "s3:GetObject",
      "s3:ListBucket",
    ]

    resources = [
      aws_s3_bucket.dg_scoreboard_frontend_bucket.arn,
      "${aws_s3_bucket.dg_scoreboard_frontend_bucket.arn}/*",
    ]

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [aws_cloudfront_distribution.dg_scoreboard_s3_distribution.arn]
    }
  }
}