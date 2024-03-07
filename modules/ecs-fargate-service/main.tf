terraform {
  required_version = ">= 1.1"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE AN ECS FARGATE CLUSTER
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_ecs_cluster" "fargate" {
  name = var.name
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE THE ECS SERVICE
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_ecs_service" "service" {
  name            = var.name
  cluster         = aws_ecs_cluster.fargate.arn
  desired_count   = var.desired_count
  launch_type     = "FARGATE"
  task_definition = aws_ecs_task_definition.service.arn

  load_balancer {
    container_name   = var.name
    container_port   = var.container_port
    target_group_arn = aws_lb_target_group.ecs.arn
  }

  network_configuration {
    subnets          = data.aws_subnets.default.ids
    security_groups  = [aws_security_group.ecs_task_security_group.id]
    assign_public_ip = true
  }

  # Ensure ALB is provisioned first
  depends_on = [aws_lb.ecs, aws_lb_listener.http, aws_lb_listener_rule.forward_all, aws_lb_target_group.ecs]
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE THE ECS TASK DEFINITION
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_ecs_task_definition" "service" {
  family                   = var.name
  network_mode             = "awsvpc"
  cpu                      = var.cpu
  memory                   = var.memory
  container_definitions    = var.container_definitions
  requires_compatibilities = ["FARGATE"]
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE A SECURITY GROUP FOR THE ECS SERVICE
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_security_group" "ecs_task_security_group" {
  name   = "${var.name}-task-access"
  vpc_id = data.aws_vpc.default.id
}

resource "aws_security_group_rule" "allow_outbound_all" {
  security_group_id = aws_security_group.ecs_task_security_group.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "allow_inbound_on_container_port" {
  security_group_id        = aws_security_group.ecs_task_security_group.id
  type                     = "ingress"
  from_port                = var.container_port
  to_port                  = var.container_port
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.alb.id
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE AN ALB TO ROUTE TRAFFIC TO THE ECS SERVICE
# ---------------------------------------------------------------------------------------------------------------------

locals {
  # An ALB can only be attached to one subnet per AZ, so filter the list of subnets to a unique one per AZ
  subnets_per_az  = { for subnet in data.aws_subnet.default : subnet.availability_zone => subnet.id... }
  subnets_for_alb = [for az, subnets in local.subnets_per_az : subnets[0]]
}

resource "aws_lb" "ecs" {
  name               = var.name
  load_balancer_type = "application"
  subnets            = local.subnets_for_alb
  security_groups    = [aws_security_group.alb.id]
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.ecs.arn
  port              = var.alb_port
  protocol          = "HTTP"

  # By default, return a simple 404 page
  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "404: page not found"
      status_code  = 404
    }
  }
}

resource "aws_lb_target_group" "ecs" {
  name_prefix = substr(var.name, 0, 6)
  port        = var.container_port
  protocol    = "HTTP"
  vpc_id      = data.aws_vpc.default.id
  target_type = "ip"

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 15
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_listener_rule" "forward_all" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 100

  condition {
    path_pattern {
      values = ["*"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs.arn
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE A SECURITY GROUP FOR THE ALB
# To keep the example simple, we configure the ALB to allow inbound requests from anywhere. We also allow it to make
# outbound requests to anywhere so it can perform health checks. In real-world usage, you should lock the ALB down
# so it only allows traffic to/from trusted sources.
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_security_group" "alb" {
  name = "${var.name}-alb"
}

resource "aws_security_group_rule" "alb_allow_http_inbound" {
  type              = "ingress"
  from_port         = var.alb_port
  to_port           = var.alb_port
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.alb.id
}

resource "aws_security_group_rule" "alb_allow_all_outbound" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.alb.id
}
