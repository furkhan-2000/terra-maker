resource "aws_s3_bucket" "lenovo" {
  bucket = "mirinda-soda" # normal bucket creation 

  tags = {
    Name = "terra-bucket"
  }
}

resource "aws_s3_bucket_versioning" "HP" {
  bucket = aws_s3_bucket.lenovo.id
  versioning_configuration { #versioning for tracking previous state files
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "vivo" {
  bucket = aws_s3_bucket.lenovo.id
  rule { # encrypting form server side
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "dell" {
  bucket                  = aws_s3_bucket.lenovo.id
  block_public_acls       = true
  block_public_policy     = true # blocking all public access
  ignore_public_acls      = true
  restrict_public_buckets = true
}