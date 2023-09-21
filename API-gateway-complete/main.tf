# Create an API Gateway
resource "aws_api_gateway_rest_api" "employee-api" {
  name        = "employee-api"
  description = "Employee API Gateway"
}

# Create a GET method
resource "aws_api_gateway_method" "get_method" {
  rest_api_id   = aws_api_gateway_rest_api.employee-api.id
  resource_id   = aws_api_gateway_rest_api.employee-api.root_resource_id
  http_method   = "GET"
  authorization = "NONE"
}

# Create a POST method
resource "aws_api_gateway_method" "post_method" {
  rest_api_id   = aws_api_gateway_rest_api.employee-api.id
  resource_id   = aws_api_gateway_rest_api.employee-api.root_resource_id
  http_method   = "POST"
  authorization = "NONE"
}

# Create a Lambda integration for the GET method
resource "aws_api_gateway_integration" "get_integration" {
  rest_api_id             = aws_api_gateway_rest_api.employee-api.id
  resource_id             = aws_api_gateway_rest_api.employee-api.root_resource_id
  http_method             = aws_api_gateway_method.get_method.http_method
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = aws_lambda_function.getEmployee1.invoke_arn
}

# Create a Lambda integration for the POST method
resource "aws_api_gateway_integration" "post_integration" {
  rest_api_id             = aws_api_gateway_rest_api.employee-api.id
  resource_id             = aws_api_gateway_rest_api.employee-api.root_resource_id
  http_method             = aws_api_gateway_method.post_method.http_method
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = aws_lambda_function.insertEmployeeData1.invoke_arn
}

# Deploy the API Gateway
resource "aws_api_gateway_deployment" "deployment" {
  depends_on  = [
    aws_api_gateway_integration.get_integration,
    aws_api_gateway_integration.post_integration
  ]
  rest_api_id = aws_api_gateway_rest_api.employee-api.id
  stage_name  = "Prod"
}

# Add permission for API Gateway to invoke the Lambda function for the GET method
resource "aws_lambda_permission" "api_gateway_invoke_permission_get" {
  statement_id  = "AllowAPIGatewayInvokeGET"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.getEmployee1.arn
  principal     = "apigateway.amazonaws.com"
  # source_arn = "arn:aws:execute-api:${var.myregion}:${var.accountId}:${aws_api_gateway_rest_api.employee-api.id}/*/*/*"
  source_arn = "arn:aws:execute-api:${var.myregion}:${var.accountId}:${aws_api_gateway_rest_api.employee-api.id}/*/${aws_api_gateway_method.get_method.http_method}/*"

  # source_arn    = "${aws_api_gateway_rest_api.employee-api.execution_arn}/*"
}

# Add permission for API Gateway to invoke the Lambda function for the POST method
resource "aws_lambda_permission" "api_gateway_invoke_permission_post" {
  statement_id  = "AllowAPIGatewayInvokePOST"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.insertEmployeeData1.arn
  principal     = "apigateway.amazonaws.com"
  # source_arn = "arn:aws:execute-api:${var.myregion}:${var.accountId}:${aws_api_gateway_rest_api.employee-api.id}/*/*/*"
  source_arn = "arn:aws:execute-api:${var.myregion}:${var.accountId}:${aws_api_gateway_rest_api.employee-api.id}/*/${aws_api_gateway_method.post_method.http_method}/*"

  # source_arn    = "${aws_api_gateway_rest_api.employee-api.execution_arn}/*"
}

resource "aws_api_gateway_method_response" "get_response" {
  rest_api_id = aws_api_gateway_rest_api.employee-api.id
  resource_id = aws_api_gateway_rest_api.employee-api.root_resource_id
  http_method = aws_api_gateway_method.get_method.http_method
  status_code = "200"
  depends_on  = [aws_api_gateway_integration.get_integration]
  
}

resource "aws_api_gateway_method_response" "post_response" {
  rest_api_id = aws_api_gateway_rest_api.employee-api.id
  resource_id = aws_api_gateway_rest_api.employee-api.root_resource_id
  http_method = aws_api_gateway_method.post_method.http_method
  status_code = "200"
  depends_on  = [aws_api_gateway_integration.post_integration]
}

resource "aws_api_gateway_integration_response" "get_response" {
  rest_api_id           = aws_api_gateway_rest_api.employee-api.id
  resource_id           = aws_api_gateway_rest_api.employee-api.root_resource_id
  http_method           = aws_api_gateway_method.get_method.http_method
  status_code           = aws_api_gateway_method_response.get_response.status_code
  response_templates = {
    "application/json" = ""
  }
}

resource "aws_api_gateway_integration_response" "post_response" {
  rest_api_id           = aws_api_gateway_rest_api.employee-api.id
  resource_id           = aws_api_gateway_rest_api.employee-api.root_resource_id
  http_method           = aws_api_gateway_method.post_method.http_method
  status_code           = aws_api_gateway_method_response.post_response.status_code
  response_templates = {
    "application/json" = ""
  }
}

# core enable module
module "example_cors" {
  source  = "mewa/apigateway-cors/aws"
  version = "2.0.1"

  api      = aws_api_gateway_rest_api.employee-api.id
  resource = aws_api_gateway_rest_api.employee-api.root_resource_id
  methods = ["GET", "POST"]


  depends_on = [ aws_api_gateway_deployment.deployment ]
}

