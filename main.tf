resource "aws_ecr_repository" "my_repo" {
  name = "my-repo"
}
resource "aws_ecs_cluster" "my_cluster" {
  name = "my-cluster"
}
resource "aws_ecs_task_definition" "my_task" {
  family                   = "my-task"
  container_definitions    = <<DEFINITION
[
  {
    "name": "my-container",
    "image": "${aws_ecr_repository.my_repo.repository_url}:latest",
    "cpu": 256,
    "memory": 512,
    "essential": true
  }
]
DEFINITION
}
resource "aws_ecs_service" "my_service" {
  name            = "my-service"
  cluster         = aws_ecs_cluster.my_cluster.id
  task_definition = aws_ecs_task_definition.my_task.arn
  desired_count   = 1

  deployment_controller {
    type = "ECS"
  }

  network_configuration {
    security_groups = [aws_security_group.my_sg.id]
    subnets         = [aws_subnet.my_subnet.id]
  }
}
resource "aws_security_group" "my_sg" {
  name_prefix = "my-sg"
}

resource "aws_subnet" "my_subnet" {
  cidr_block = "10.0.1.0/24"
}