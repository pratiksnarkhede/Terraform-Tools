output "bucket_name" {
  value = aws_s3_bucket.s3bucketdemo777.bucket
}

output "website_endpoint" {
  value = aws_s3_bucket.s3bucketdemo777.website_endpoint
}