output "endpoint" {
  value = "${aws_db_instance.mysql.endpoint}"
}

output "arn" {
  value = "${aws_db_instance.mysql.arn}"
}
