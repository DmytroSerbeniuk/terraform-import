resource "aws_s3_bucket" "yeew" {
  bucket = "yeew.de-dev"
  object_lock_enabled = false
}

resource "aws_s3_bucket_cors_configuration" "yeew" {
  bucket = aws_s3_bucket.yeew.id

  cors_rule {
    allowed_headers = ["Authorization"]
    allowed_methods = ["GET", "HEAD"]
    allowed_origins = ["3333yeew.de","*.3333yeew.de"]
    expose_headers  = ["Access-Control-Allow-Origin"]
    max_age_seconds = 0
  }
}
resource "aws_s3_bucket_public_access_block" "yeew" {
  bucket = aws_s3_bucket.yeew.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_metric" "yeew" {
  bucket = aws_s3_bucket.yeew.id
  name   = "EntireBucket"
}

# import {
#   # ID of the cloud resource
#   # Check provider documentation for importable resources and format
#   id = "yeew.de-dev"
 
#   # Resource address
#   to = aws_s3_bucket.yeew
# }