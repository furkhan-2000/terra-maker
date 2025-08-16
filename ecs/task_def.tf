resource "aws_ecs_task_definition" "appe-task" {
  family                   = var.family
  execution_role_arn       = aws_iam_role.ecs-task-execution.arn
  network_mode             = var.network_mode
  requires_compatibilities = var.compatibilities
  cpu                      = var.cpu[terraform.workspace]
  memory                   = terraform.workspace == "prd" ? "800" : "400"

  container_definitions = jsonencode([
    {
      # Container-1 
      name      = var.container_name1
      image     = var.container_image1
      essential = var.essential1
      memory    = var.container_memory1[terraform.workspace]
      cpu       = var.container_cpu1[terraform.workspace]
      portMappings = [
        {
          containerPort = var.con_port1
          protocol      = var.protocol1
        }
      ]
      environment = [
        { name = "Environment", value = terraform.workspace }
      ]
      readOnlyRootFilesystem = var.readOnlyRootFilesystem1
    },
    {
      # Container- 2 
      name      = var.container_name2
      image     = var.container_image2
      essential = var.essential2
      memory    = var.container_memory2[terraform.workspace]
      cpu       = var.container_cpu2[terraform.workspace]
      portMappings = [
        {
          containerPort = var.con_port2
          protocol      = var.protocol2
        }
      ]
      environment = [
        { name = "Environment", value = terraform.workspace }
      ]
      readOnlyRootFilesystem = var.readOnlyRootFilesystem2
    }
  ])


  tags = {
    Environment = terraform.workspace
    service     = "apple"
  }
}

# ECS task executin role 
resource "aws_iam_role" "ecs-task-execution" {
  name = var.task_exec

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com" # Note: ecs-tasks, not ec2
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role" {
  role       = aws_iam_role.ecs-task-execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
