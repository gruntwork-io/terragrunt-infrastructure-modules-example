resource "aws_secretsmanager_secret" "this" {
  for_each = { for secret in var.secrets : secret.name => secret }

  name        = each.value.name
  description = lookup(each.value, "description", null)
}
