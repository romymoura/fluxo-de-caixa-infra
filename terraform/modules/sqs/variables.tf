variable "queue_name" {
  description = "Nome da fila SQS para o fluxo de caixa"
  type        = string
  default     = "fluxo_caixa_queue"
}

variable "dlq_name" {
  description = "Nome da Dead Letter Queue (DLQ) para o fluxo de caixa"
  type        = string
  default     = "fluxo_caixa_dlq"
}