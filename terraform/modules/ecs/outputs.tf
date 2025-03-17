output "api_service_url" {
  value = aws_lb_listener.api_listener.arn
}


output "ecs_task_execution_role_arn" {
  value = aws_iam_role.ecs_task_execution_role.arn
  description = "O ARN do IAM Role de execução da tarefa ECS"
}

