##please create all above resources in terraform modules approach
# loadbalancer security group for service and security group for laodbalancer
#Create task role
resource "aws_iam_role" "task_role" {
  name               = "my-task-role"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "ecs-tasks.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}

###Create task execution role
resource "aws_iam_role" "task_execution_role" {
  name               = "my-task-execution-role"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "ecs-tasks.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "task_execution_role_policy" {
  role       = aws_iam_role.task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

#Create amazon ECR repo
resource "aws_ecr_repository" "my_ecr_repo" {
  name                 = "my-ecr-repo"
  image_scanning_configuration {
    scan_on_push = true
  }
}
###Create task definition

resource "aws_ecs_task_definition" "fargate_task_definition" {
  family                   = var.task-definition.task_family
  cpu                      = var.task-definition.task_cpu
  memory                   = var.task-definition.task_memory
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  execution_role_arn       = aws_iam_role.task_execution_role.arn
  task_role_arn            = aws_iam_role.task_role.arn

  container_definitions = jsonencode([
    {
      name      = var.task-definition.container_name
      image     = aws_ecr_repository.my_ecr_repo.repository_url
      cpu       = var.task-definition.task_cpu
      memory    = var.task-definition.task_memory
      essential = true
      portMappings = [
        {
          containerPort = var.task-definition.container_port
          # hostPort      = var.container_port
          protocol      = "tcp"
        }
      ],
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "/ecs/${var.task-definition.task_family}"
          "awslogs-region"        = var.region
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])
}
# Create the CloudWatch Logs group
resource "aws_cloudwatch_log_group" "ecs_task_log_group" {
  name              = "/ecs/${var.task-definition.task_family}"
  retention_in_days = 30
}