resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecs-task-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_ecs_cluster" "cluster" {
  name = var.ecs_cluster_name
}


resource "aws_ecs_task_definition" "api_task" {
  family                   = "api-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = "api-lancamento-container"
      image     = "api-lancamento-image"
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
      environment = [
        {
          name  = "RDS_ENDPOINT"
          value = var.rds_endpoint
        },
        {
          name  = "SQS_QUEUE_URL"
          value = var.sqs_queue_url
        }
      ]
    }
  ])
}


resource "aws_ecs_service" "api_service" {
  name            = "api-lancamento"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.api_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"  # Pode ser "FARGATE" ou "EC2", dependendo da sua configuração

  network_configuration {
    subnets          = var.subnet_ids
    security_groups = [aws_security_group.lb_sg.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.fluxo_de_caixa_lb_tg.arn
    container_name   = "api-lancamento-container"
    container_port   = 80
  }

  depends_on = [aws_lb_listener.api_listener]
}


resource "aws_ecs_task_definition" "worker_task" {
  family                   = "worker-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = "worker-consolidacao-container"
      image     = "worker-consolidacao-image"
      essential = true
      environment = [
        {
          name  = "SQS_QUEUE_URL"
          value = var.sqs_queue_url
        },
        {
          name  = "S3_BUCKET_NAME"
          value = var.s3_bucket_name
        }
      ]
    }
  ])
}


resource "aws_ecs_service" "worker_service" {
  name            = "worker-consolidacao"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.worker_task.arn
  desired_count   = 1

  network_configuration {
    subnets          = var.subnet_ids
    security_groups = [aws_security_group.lb_sg.id]
    assign_public_ip = true
  }
  launch_type = "FARGATE"
}




resource "aws_security_group" "lb_sg" {
  name        = "lb-security-group"
  description = "Security group para o Load Balancer"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb" "fluxo_de_caixa_lb" {
  name               = "api-lancamento-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            =  var.subnet_ids

  enable_deletion_protection = false
  enable_cross_zone_load_balancing = true
}

resource "aws_lb_target_group" "fluxo_de_caixa_lb_tg" {
  name     = "fluxo-de-caixa-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  target_type = "ip"

  health_check {
    interval            = 30
    path                = "/health"
    port                = 80
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
}

# resource "aws_lb_listener_rule" "api_listener_rule" {
#   listener_arn = aws_lb_listener.api_listener.arn
#   priority     = 1

#   action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.fluxo_de_caixa_lb_tg.arn
#   }

#   condition {
#     field  = "path-pattern"
#     values = ["/api/*"]
#   }

#   condition {
#     field  = "host-header"
#     values = ["example.com"]
#   }
# }

resource "aws_lb_listener_rule" "api_listener_rule" {
  listener_arn = aws_lb_listener.api_listener.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.fluxo_de_caixa_lb_tg.arn
  }

  condition {
    path_pattern {
      values = ["/api/*"]
    }
  }
  # condition {
  #   host_header {
  #     values = ["example.com"]
  #   }
  # }
}


resource "aws_lb_listener" "api_listener" {
  load_balancer_arn = aws_lb.fluxo_de_caixa_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "fixed-response"
    fixed_response {
      status_code = "200"
      content_type = "text/plain"
      message_body = "OK"
    }
  }
}
