# Create a DynamoDB table
resource "aws_dynamodb_table" "employee_table" {
  name         = "employee-table"
  billing_mode = "PROVISIONED"
  read_capacity  = 1 
  write_capacity = 1  
  hash_key     = "empId"

  attribute {
    name = "empId"
    type = "S"
  }
}

# Create a Lambda function-1
resource "aws_lambda_function" "getEmployee1" {
  filename      = "getEmployee1.zip"     # Path to your Lambda function code
  function_name = "getEmployee1"
  role          = aws_iam_role.lambda_API_role.arn

  handler = "getEmployee1.lambda_handler"
  runtime = "python3.10"                   # Change to your desired runtime

  source_code_hash = filebase64sha256("getEmployee1.zip")
   depends_on = [ aws_dynamodb_table.employee_table ]
}

#Create a Lambda function-2 for inserting data
resource "aws_lambda_function" "insertEmployeeData1" {
  filename      = "insertEmployeeData1.zip"     # Path to your Lambda function code
  function_name = "insertEmployeeData1"
  role          = aws_iam_role.lambda_API_role.arn

  handler = "insertEmployeeData1.lambda_handler"
  runtime = "python3.10"                   # Change to your desired runtime

  source_code_hash = filebase64sha256("insertEmployeeData1.zip")
  depends_on = [ aws_dynamodb_table.employee_table ]
}

# Create an IAM role for the Lambda function
resource "aws_iam_role" "lambda_API_role" {
  name = "lambda_API_role"

  assume_role_policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "lambda_dynamodb_policy" {
  name        = "LambdaDynamoDBPolicy"
  description = "Policy for Lambda to access DynamoDB"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "dynamodb:*"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_dynamodb_policy_attachment" {
  policy_arn = aws_iam_policy.lambda_dynamodb_policy.arn
  role       = aws_iam_role.lambda_API_role.name
}

resource "aws_iam_policy" "lambda_cloudwatch_policy" {
  name        = "CloudWatchFullAccessPolicy"
  description = "Policy for CloudWatch full access"

  # Specify the permissions for CloudWatch full access.
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "cloudwatch:*",
            "Resource": "*"
        }
    ]
}
EOF
}

# Attach the CloudWatch policy to the Lambda role
resource "aws_iam_role_policy_attachment" "lambda_cloudwatch_policy_attachment" {
  policy_arn = aws_iam_policy.lambda_cloudwatch_policy.arn
  role       = aws_iam_role.lambda_API_role.name
  depends_on = [aws_iam_role.lambda_API_role] # Ensure the Lambda role is created before attaching the policy
}

# Add AWSLambdaBasicExecutionRole managed policy to the Lambda role
resource "aws_iam_policy_attachment" "lambda_basic_execution_attachment" {
  name       = "LambdaBasicExecutionAttachment"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  roles      = [aws_iam_role.lambda_API_role.name]
}


