output "api_endpoint" {
  value = module.lambda_service.api_endpoint
}

output "apigatewayv2_api_id" {
  value = module.lambda_service.apigatewayv2_api_id
}

output "apigatewayv2_default_stage_id" {
  value = module.lambda_service.apigatewayv2_default_stage_id
}

output "function_arn" {
  value = module.lambda_service.function_arn
}