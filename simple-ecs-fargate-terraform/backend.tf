# ECS Fargate setups

resource "aws_ecs_task_definition" "squid_backend" {
  depends_on = [
    data.aws_iam_role.ecsTaskExecutionRole,
    aws_ecs_cluster.squid,
    aws_docdb_cluster.squid
  ]

  container_definitions = <<DEFINITION
  [
    {
      "name": "squid-backend",
      "image": "565906264822.dkr.ecr.ap-northeast-2.amazonaws.com/squid-backend:0.0.5",
      "cpu": 256,
      "memory": 1024,
      "portMappings": [
        {
          "hostPort": 6449,
          "containerPort": 6449,
          "protocol": "tcp"
        }
      ],
      "essential": true,
      "environment": [
        {
          "name": "MONGODB_PATH",
          "value": "mongodb://squid:dhdlfskarnt@${aws_docdb_cluster.squid.endpoint}:27017"
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

resource "aws_ecs_service" "squid_backend" {
  depends_on = [
    aws_lb_listener.squid_backend,
    aws_ecs_cluster.squid,
    aws_docdb_cluster_instance.squid_instance
  ]

  name            = "squid-service-backend"
  cluster         = aws_ecs_cluster.squid.id
  task_definition = aws_ecs_task_definition.squid_backend.arn
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
    target_group_arn = aws_lb_target_group.squid_backend.arn
    container_name   = "squid-backend"
    container_port   = 6449
  }
}

resource "aws_lb" "squid_backend" {
  name               = "squid-lb-backend"
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

resource "aws_lb_target_group" "squid_backend" {
  depends_on = [
    aws_lb.squid_backend
  ]

  name        = "squid-backend-target-group"
  target_type = "ip"
  port        = 6449
  protocol    = "HTTP"
  vpc_id      = aws_vpc.squid.id
}

resource "aws_lb_listener" "squid_backend" {
  load_balancer_arn = aws_lb.squid_backend.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.squid_backend.arn
  }
}
