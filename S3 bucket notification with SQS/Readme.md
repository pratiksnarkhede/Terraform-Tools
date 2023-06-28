Terraform AWS SQS and S3 Bucket Configuration
This Terraform configuration creates an AWS Simple Queue Service (SQS) queue and an S3 bucket with notifications to the SQS queue. The SQS queue is configured to receive notifications whenever new objects are created in the S3 bucket.

Prerequisites
Before you begin, ensure that you have the following:

AWS CLI installed and configured with your AWS credentials.
Terraform installed on your local machine.
Configuration
The configuration is divided into three parts: creating the SQS queue, creating the S3 bucket, and configuring S3 bucket notifications.

1. Creating the SQS Queue
The aws_sqs_queue resource is used to create an SQS queue. The queue is given the name "demo_queue" and a policy file is attached to it.


resource "aws_sqs_queue" "demo_queue" {
  name   = "demo_queue"
  policy =  file("${path.module}/s3_notification_policy.json") 
}
Make sure to provide the correct path to the s3_notification_policy.json file in the policy attribute.

2. Creating the S3 Bucket
The aws_s3_bucket resource is used to create an S3 bucket. The bucket is given the name "pratikbucket777" and the force_destroy parameter is set to true, enabling the bucket to be forcefully destroyed.

resource "aws_s3_bucket" "pratikbucket777" {
  bucket        = "pratikbucket777"
  force_destroy = true
}
Feel free to change the bucket name according to your requirements.

3. Configuring S3 Bucket Notifications
The aws_s3_bucket_notification resource is used to configure notifications on the S3 bucket. In this configuration, the bucket will send notifications to the SQS queue whenever new objects are created. The filter suffix is set to ".webp" to filter only objects with the .webp file extension.


resource "aws_s3_bucket_notification" "sqsbucketnotification" {
  bucket = aws_s3_bucket.pratikbucket777.id

  queue {
    queue_arn     = aws_sqs_queue.demo_queue.arn
    events        = ["s3:ObjectCreated:*"]
    filter_suffix = ".webp"
  }
}
Ensure that you provide the correct ARN for the SQS queue in the queue_arn attribute.

Deployment

To deploy this configuration, follow these steps:

Clone or download the repository containing the Terraform configuration files.

Open a terminal and navigate to the directory where the configuration files are located.

Run terraform init to initialize the Terraform working directory.

Run terraform plan to see the execution plan.

Run terraform apply to apply the configuration and create the SQS queue and S3 bucket.

Cleanup
To clean up and destroy the resources created by this configuration, run the following command:


terraform destroy
This will destroy the SQS queue and S3 bucket along with their associated resources.

Disclaimer
This configuration is provided as an example and should be used with caution in production environments. Make sure to review and customize the configuration according to your specific requirements and best practices.

Please refer to the official Terraform documentation for detailed information on each resource and configuration option.
