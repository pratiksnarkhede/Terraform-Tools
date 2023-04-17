

resource "aws_sqs_queue" "demo_queue" {
  name   = "demo_queue"
  policy =  file("${path.module}/s3_notification_policy.json") 
}

resource "aws_s3_bucket" "pratikbucket777" {
  bucket = "pratikbucket777"
  force_destroy = true
}

resource "aws_s3_bucket_notification" "sqsbucketnotification" {
  bucket = aws_s3_bucket.pratikbucket777.id

  queue {
    queue_arn     = aws_sqs_queue.demo_queue.arn
    events        = ["s3:ObjectCreated:*"]
    filter_suffix = ".webp"
  }
  
}