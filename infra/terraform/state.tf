# S3 bucket for terraform state
# Note: This is imported after initial creation to avoid chicken-and-egg problem

resource "aws_s3_bucket" "terraform_state" {
  bucket = "able-terraform-state-${data.aws_caller_identity.current.account_id}"

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name = "Terraform State"
  }
}

resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Note: Using S3 native locking (use_lockfile = true) instead of DynamoDB
# DynamoDB table removed - was "able-terraform-locks"

output "terraform_state_bucket" {
  value       = aws_s3_bucket.terraform_state.id
  description = "S3 bucket for terraform state"
}
