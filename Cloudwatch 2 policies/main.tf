# Define the AWS provider
provider "aws" {
  region = "us-east-1"  # Replace with your desired AWS region
}

# Define the IAM user resource
resource "aws_iam_user" "users" {
  name = "users"  # Replace with your desired IAM user name
}

variable "give_cloudwatch_full_access" {
  description = "If true,  gets full access to CloudWatch"
  type        = bool
}

# Define the IAM policies
resource "aws_iam_policy" "cloudwatch_full_access" {
   count = var.give_cloudwatch_full_access ? 1 : 0
  name   = "cloudwatch_full_access"
  policy = data.aws_iam_policy_document.cloudwatch_full_access.json
}

data "aws_iam_policy_document" "cloudwatch_full_access" {
  statement {
    effect    = "Allow"
    actions   = ["cloudwatch:*"]
    resources = ["*"]
  }
}


resource "aws_iam_policy" "cloudwatch_read_only" {
    count = var.give_cloudwatch_full_access ? 0 : 1
   name   = "cloudwatch-read-only"
  policy = data.aws_iam_policy_document.cloudwatch_read_only.json
}
data "aws_iam_policy_document" "cloudwatch_read_only" {
  statement {
    effect    = "Allow"
    actions   = [
      "cloudwatch:Describe*",
      "cloudwatch:Get*",
      "cloudwatch:List*"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_user_policy_attachment" "full_access" {
  count = var.give_cloudwatch_full_access ? 1 : 0

  user       = aws_iam_user.users.name
  policy_arn = aws_iam_policy.cloudwatch_full_access[count.index].arn
}

resource "aws_iam_user_policy_attachment" "read_only" {
  count = var.give_cloudwatch_full_access ? 0 : 1

  user       = aws_iam_user.users.name
  policy_arn = aws_iam_policy.cloudwatch_read_only[count.index].arn
}

