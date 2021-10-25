resource "aws_ecs_task_definition" "squid_frontend" {
  depends_on = [
    data.aws_iam_role.ecsTaskExecutionRole,
    aws_ecs_cluster.squid,
    aws_ecs_service.squid_backend
  ]

  container_definitions = <<DEFINITION
  [
    {
      "name": "squid-frontend",
      "image": "565906264822.dkr.ecr.ap-northeast-2.amazonaws.com/squid-frontend:0.0.12",
      "cpu": 256,
      "memory": 1024,
      "portMappings": [
        {
          "hostPort": 3000,
          "containerPort": 3000,
          "protocol": "tcp"
        }
      ],
      "essential": true,
      "environment": [
        {
          "name": "REACT_APP_API_ENDPOINT",
          "value": "http://${aws_lb.squid_backend.dns_name}"
        }
      ]
    }
  ]
  DEFINITION

  family                   = "squid"
  network_mode             = "awsvpc"
  memory                   = "2048"
  cpu                      = "512"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = data.aws_iam_role.ecsTaskExecutionRole.arn
}

resource "aws_ecs_service" "squid_frontend" {
  depends_on = [
    aws_lb_listener.squid_frontend,
    aws_ecs_cluster.squid,
    aws_ecs_service.squid_backend
  ]

  name            = "squid-service-frontend"
  cluster         = aws_ecs_cluster.squid.id
  task_definition = aws_ecs_task_definition.squid_frontend.arn
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
    target_group_arn = aws_lb_target_group.squid_frontend.arn
    container_name   = "squid-frontend"
    container_port   = 3000
  }
}

resource "aws_lb" "squid_frontend" {
  name               = "squid-lb-frontend"
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

resource "aws_lb_target_group" "squid_frontend" {
  depends_on = [
    aws_lb.squid_frontend
  ]

  name        = "squid-frontend-target-group"
  target_type = "ip"
  port        = 3000
  protocol    = "HTTP"
  vpc_id      = aws_vpc.squid.id
}

resource "aws_lb_listener" "squid_frontend" {
  load_balancer_arn = aws_lb.squid_frontend.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.squid_frontend.arn
  }
}
