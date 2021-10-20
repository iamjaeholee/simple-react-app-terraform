# ECS Fargate setups
resource "aws_ecs_cluster" "squid" {
  depends_on = [
    aws_vpc.squid
  ]

  name = "squid"
}

data "aws_iam_role" "ecsTaskExecutionRole" {
  name = "ecsTaskExecutionRole"
}
