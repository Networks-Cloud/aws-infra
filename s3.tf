resource "aws_s3_bucket_lifecycle_configuration" "s3_lifecylce_config" {
  bucket = aws_s3_bucket.private_bucket.id

  rule {
    id     = "rule-1"
    status = "Enabled"

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }
  }
  depends_on = [
    aws_s3_bucket.private_bucket
  ]
}

resource "aws_s3_bucket_server_side_encryption_configuration" "s3_server_side_config" {
  bucket = aws_s3_bucket.private_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "random_string" "bucket_name" {
  length  = 10
  special = false
  upper   = false
  numeric = false
}

resource "aws_s3_bucket" "private_bucket" {
  bucket = random_string.bucket_name.result

  force_destroy = true
}

resource "aws_s3_bucket_acl" "example_bucket_acl" {
  bucket = aws_s3_bucket.private_bucket.id
  acl    = "private"

}
