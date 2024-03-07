output "api_endpoint" {
  value = aws_apigatewayv2_api.api.api_endpoint
}

output "apigatewayv2_api_id" {
  value = aws_apigatewayv2_api.api.id
}

output "apigatewayv2_default_stage_id" {
  value = aws_apigatewayv2_stage.default.id
}

output "function_arn" {
  value = aws_lambda_function.function.arn
}