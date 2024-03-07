terraform {
  required_version = ">= 1.1"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.0"
    }
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE THE LAMBDA FUNCTION
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_lambda_function" "function" {
  function_name = var.name
  role          = aws_iam_role.lambda.arn

  package_type     = "Zip"
  filename         = data.archive_file.source_code.output_path
  source_code_hash = data.archive_file.source_code.output_base64sha256

  runtime = var.runtime
  handler = var.handler

  memory_size = var.memory
  timeout     = var.timeout
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE THE IAM ROLE
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_iam_role" "lambda" {
  name               = var.name
  assume_role_policy = data.aws_iam_policy_document.policy.json
}

data "aws_iam_policy_document" "policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# ZIP UP THE SOURCE CODE
# ---------------------------------------------------------------------------------------------------------------------

data "archive_file" "source_code" {
  type        = "zip"
  source_dir  = var.source_dir
  output_path = "${path.module}/${var.name}.zip"
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE AN HTTP (V2) API GATEWAY TO SEND REQUESTS TO THE LAMBDA FUNCTION
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_apigatewayv2_api" "api" {
  name          = var.name
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.api.id
  name        = "$default"
  auto_deploy = true
}

# ---------------------------------------------------------------------------------------------------------------------
# CONFIGURE ROUTING FOR THE FUNCTION
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_apigatewayv2_integration" "lambda" {
  api_id             = aws_apigatewayv2_api.api.id
  integration_type   = "AWS_PROXY"
  integration_uri    = aws_lambda_function.function.arn
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "lambda_route" {
  api_id    = aws_apigatewayv2_api.api.id
  route_key = var.route_key
  target    = "integrations/${aws_apigatewayv2_integration.lambda.id}"
}

# ---------------------------------------------------------------------------------------------------------------------
# ALLOW API GATEWAY TO CALL THE LAMBDA FUNCTION
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_lambda_permission" "allow_invoke" {
  statement_id  = "AllowAPIGateway${var.name}"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.function.arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.api.execution_arn}/*/${local.route_key_method}${local.route_key_path}"
}

locals {
  route_key_parts  = split(" ", var.route_key)
  route_key_method = local.route_key_parts[0]
  route_key_path   = local.route_key_parts[1]
}