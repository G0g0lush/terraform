resource "aws_s3_bucket" "main" {
  bucket = var.bucket
  tags = var.tags
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.main.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "main" {
  bucket = aws_s3_bucket.main.id

  rule {
    id = var.lifecycle_id

    expiration {
      days = var.lifecycle_days
    }

    filter {
        prefix = var.lifecycle_prefix
        
      }
    status = var.lifecycle_status  
    }
  }

resource "aws_s3_bucket_replication_configuration" "replication" {

  depends_on = [aws_s3_bucket_versioning.versioning]

  role   = var.role
  bucket = aws_s3_bucket.main.id

  rule {
    id = var.replication_id

    filter {
      prefix = var.replication_prefix
    }

    status = var.replication_status

    destination {
      bucket        = var.replication_destination
    }
    delete_marker_replication {
      status = "Enabled"
    }
  }
}