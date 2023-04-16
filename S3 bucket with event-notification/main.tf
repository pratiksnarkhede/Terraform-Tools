resource "aws_sns_topic" "s3notitopic" {
  name   = "s3notitopic"
  policy = file("${path.module}/s3_notification_policy.json") 
}

resource "aws_s3_bucket" "s3bucketdemo777" {
  bucket = "s3bucketdemo777"
  force_destroy = true
}

resource "aws_s3_bucket_notification" "demopratiknoti" {
  bucket = aws_s3_bucket.s3bucketdemo777.id

  topic {
    topic_arn     =  aws_sns_topic.s3notitopic.arn
    events        = ["s3:ObjectCreated:*"]
    filter_suffix = ".webp"
  }
}
