resource "aws_ecs_service" "apple-vala" {
  name                              = var.ecs_name
  cluster                           = aws_ecs_cluster.main-cluster.id
  task_definition                   = aws_ecs_task_definition.appe-task.arn
  desired_count                     = var.desired_count[terraform.workspace]
  launch_type                       = var.launch_type
  health_check_grace_period_seconds = 300

  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  ordered_placement_strategy {
    type  = var.placement_strategy_type1
    field = var.placement_strategy_field1
  }

  ordered_placement_strategy {
    type  = var.placement_strategy_type2
    field = var.placement_strategy_field2
  }

  tags = {
    Environment = terraform.workspace
    Service     = "apple"
  }
}
