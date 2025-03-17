variable "prometheus_namespace" {
  description = "Namespace para o Prometheus"
  type        = string
  default     = "prometheus"
}

variable "grafana_namespace" {
  description = "Namespace para o Grafana"
  type        = string
  default     = "grafana"
}

// TODO: Tentar separar cluster.
variable "ecs_task_execution_role_arn" {
  description = "O ARN do IAM Role de execução da tarefa ECS"
  type        = string
}