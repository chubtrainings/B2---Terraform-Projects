output "bucket_access_type" {
  value = aws_s3_bucket.temps3.acl
}