resource "aws_ecs_task_definition" "service" {
  family = "worker"
  container_definitions = jsonencode([
    {
      name      = "runner"
      image     = "myoung34/github-runner"
      cpu       = 0
      memory    = 1024
      essential = true
      environment = [
        {
          name  = "REPO_URL"
          value = "https://github.com/ultramozg/spring-boot"
        },
        {
          name  = "RUNNER_NAME"
          value = "default_runner"
        },
        {
          name  = "ACCESS_TOKEN"
          value = "<PAT_TOKEN>"
        },
        {
          name  = "RUNNER_WORKDIR"
          value = "/tmp/github-runner"
        },
        {
          name  = "ORG_RUNNER",
          value = "false"
        },
        {
          name  = "LABELS",
          value = "linux,x64"
        }
      ]
      mountPoints = [
        {
          readOnly      = false,
          containerPath = "/var/run/docker.sock",
          sourceVolume  = "docker"
        },
        {
          readOnly      = false,
          containerPath = "/tmp/github-runner",
          sourceVolume  = "workdir"
        }
      ],
    }
  ])

  volume {
    name      = "docker"
    host_path = "/var/run/docker.sock"
  }

  volume {
    name      = "workdir"
    host_path = "/tmp/github-runner"
  }
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
  desired_count   = 1
}