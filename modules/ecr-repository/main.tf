resource "aws_ecr_repository" "this" {
  name                 = var.repository_name
  image_tag_mutability = var.image_tag_mutability
  tags                 = var.tags

  encryption_configuration {
    encryption_type = "AES256"
  }
}

# Create a repository policy only if there are allowed_accounts.
data "aws_iam_policy_document" "repository_policy" {
  count = length(var.allowed_accounts) > 0 ? 1 : 0

  statement {
    sid    = "AllowCrossAccountPull"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = var.allowed_accounts
    }

    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:DescribeRepositories",
      "ecr:ListImages"
    ]

    resources = [aws_ecr_repository.this.arn]
  }
}

resource "aws_ecr_repository_policy" "this" {
  count      = length(var.allowed_accounts) > 0 ? 1 : 0
  repository = aws_ecr_repository.this.name
  policy     = data.aws_iam_policy_document.repository_policy[0].json
}

# Create replication configuration only if replication_destinations is provided.
resource "aws_ecr_replication_configuration" "this" {
  count = length(var.replication_destinations) > 0 ? 1 : 0

  replication_configuration {
    rule {
      dynamic "destination" {
        for_each = var.replication_destinations
        content {
          region      = destination.value.region
          registry_id = destination.value.registry_id
        }
      }
      repository_filter {
        filter      = aws_ecr_repository.this.name
        filter_type = "PREFIX_MATCH"
      }
    }
  }
}
