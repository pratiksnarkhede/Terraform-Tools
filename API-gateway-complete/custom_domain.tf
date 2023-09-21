resource "aws_api_gateway_domain_name" "custom_domain" {
  domain_name = var.custom_domain_name
  certificate_arn = var.ssl_certificate_arn
  depends_on = [ aws_api_gateway_deployment.deployment ]
} 


resource "aws_api_gateway_base_path_mapping" "base_path_mapping" {
  api_id      = aws_api_gateway_rest_api.employee-api.id
  domain_name = aws_api_gateway_domain_name.custom_domain.domain_name
  stage_name  = "Prod" # Make sure it matches the case-sensitive stage name in your deployment
  depends_on = [ aws_api_gateway_deployment.deployment ]
}



resource "aws_route53_record" "api" {
  name    = "${aws_api_gateway_domain_name.custom_domain.domain_name}"  
  type    = "A"
  zone_id = var.hosted_zone_id  

  alias {
    name                   = "${aws_api_gateway_domain_name.custom_domain.cloudfront_domain_name}"
    zone_id                = "${aws_api_gateway_domain_name.custom_domain.cloudfront_zone_id}"
    evaluate_target_health = false
  }
  depends_on = [ aws_api_gateway_base_path_mapping.base_path_mapping ]
}

