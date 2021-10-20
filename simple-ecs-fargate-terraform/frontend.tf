resource "aws_ecs_task_definition" "squid" {
  depends_on = [
    data.aws_iam_role.ecsTaskExecutionRole,
    aws_ecs_cluster.squid
  ]

  container_definitions    = file("task-definitions/squid-frontend.json")
  family                   = "squid"
  network_mode             = "awsvpc"
  memory                   = "2048"
  cpu                      = "512"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = data.aws_iam_role.ecsTaskExecutionRole.arn
}

resource "aws_ecs_service" "squid_frontend" {
  depends_on = [
    aws_lb_listener.squid,
    aws_ecs_cluster.squid,
    aws_ecs_cluster.squid,
    aws_ecs_service.squid_backend
  ]

  name            = "squid-service"
  cluster         = aws_ecs_cluster.squid.id
  task_definition = aws_ecs_task_definition.squid.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets = [
      aws_subnet.squid-publica.id,
      aws_subnet.squid-publicb.id
    ]

    security_groups = [
      aws_security_group.squid.id
    ]

    assign_public_ip = "true"
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.squid.arn
    container_name   = "squid-frontend"
    container_port   = 3000
  }
}

resource "aws_lb" "squid" {
  name               = "squid-lb"
  internal           = false
  load_balancer_type = "application"

  security_groups = [
    aws_security_group.squid.id
  ]

  subnets = [
    aws_subnet.squid-publica.id,
    aws_subnet.squid-publicb.id
  ]

  enable_deletion_protection = false

  tags = {
    Environment = "production"
  }
}

resource "aws_lb_target_group" "squid" {
  depends_on = [
    aws_lb.squid
  ]

  name        = "squid-target-group"
  target_type = "ip"
  port        = 3000
  protocol    = "HTTP"
  vpc_id      = aws_vpc.squid.id
}

resource "aws_lb_listener" "squid" {
  load_balancer_arn = aws_lb.squid.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.squid.arn
  }
}
