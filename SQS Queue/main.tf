
resource "aws_sqs_queue" "SQS_QUEUE_DEMO" {
  name                       = "sqs_queue_demo"
  delay_seconds              = 30
  max_message_size           = 256000
  message_retention_seconds  = 345600
  receive_wait_time_seconds  = 10
  visibility_timeout_seconds = 30
   redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.SQS_QUEUE_DEMO_DEAD_LETTER.arn
    maxReceiveCount     = 4
  })
}
  


resource "aws_sqs_queue" "SQS_QUEUE_DEMO_DEAD_LETTER" {
  name = "sqs_queue_demo_dead_letter"
  
}

resource "aws_sqs_queue_redrive_allow_policy" "example" {
  queue_url = aws_sqs_queue.SQS_QUEUE_DEMO_DEAD_LETTER.id

  redrive_allow_policy = jsonencode({
    redrivePermission = "byQueue",
    sourceQueueArns   = [aws_sqs_queue.SQS_QUEUE_DEMO.arn]
  })
}



