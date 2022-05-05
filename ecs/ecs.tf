resource "aws_ecs_cluster" "ecs_cluster" {
    name  = "my-cluster"
}

resource "aws_ecs_task_definition" "service" {
  family = "worker"
  container_definitions = jsonencode([
    {
      name      = "first"
      image     = "nginx"
      cpu       = 0
      memory    = 64
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
    },
    {
      name      = "second"
      image     = "nginx"
      cpu       = 0
      memory    = 64
      essential = true
      portMappings = [
        {
          containerPort = 443
          hostPort      = 443
        }
      ]
    }
  ])

  /*
  placement_constraints {
    type       = "memberOf"
    expression = "attribute:ecs.availability-zone in [us-west-2a, us-west-2b]"
  }
  */
}

resource "aws_ecs_service" "worker" {
  name            = "worker"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.service.arn
  desired_count   = 2
}