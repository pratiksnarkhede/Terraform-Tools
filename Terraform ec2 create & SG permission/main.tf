 #IAM policy for EC2 instance and Security Group management
resource "aws_iam_policy" "ec2_security_group_policy" {
  name   = "ec2_security_group_policy"
  policy = data.template_file.iam_policy.rendered
}

#  IAM policy attachment for the user
resource "aws_iam_user_policy_attachment" "ec2_security_group_policy_attachment" {
  policy_arn = aws_iam_policy.ec2_security_group_policy.arn
  user       = "demouser" # Replace with the actual username
}

# Render the IAM policy as a JSON string
data "template_file" "iam_policy" {
  template = file("${path.module}/policy.json")
}
