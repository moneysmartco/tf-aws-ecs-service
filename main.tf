locals {
  # env tag in map structure
  env_tag = { Environment = "${var.env}" }

  # project tag in map structure
  project_tag = { Project = "${var.project_name}" }

  # ecs task name tag in map structure
  ecs_task_name_tag = { Name = "${var.project_name}-${var.env}" }

  # ecs service name tag in map structure
  ecs_service_name_tag = { Name = "${var.project_name}-${var.env}" }


  #------------------------------------------------------------
  # variables that will be mapped to the various resource block
  #------------------------------------------------------------

  # ecs task definition tags
  ecs_task_definition_tags = "${merge(var.tags, local.env_tag, local.project_tag, local.ecs_task_name_tag)}"

  # ecs service tags
  ecs_service_tags = "${merge(var.tags, local.env_tag, local.project_tag, local.ecs_service_name_tag)}"
}


data "template_file" "service_server_container_definition" {
  template = "${file("${path.module}/task-definition.json.tpl")}"
  vars {
    port                        = "${var.service_app_port}"
    service_server_cpu          = "${var.service_server_cpu}"
    service_server_memory       = "${var.service_server_memory}"
    service_server_docker_image = "${var.service_server_docker_image}"
    service_container_name      = "${var.service_container_name}"
    service_container_cmd       = "${var.service_container_cmd}"
  }
}


resource "aws_ecs_task_definition" "service_server" {
  family                = "${var.project_name}-${var.env}"
  cpu                   = "${var.task_required_cpu}"
  memory                = "${var.task_required_memory}"
  container_definitions = "${data.template_file.service_server_container_definition.rendered}"
  tags                  = "${local.ecs_task_definition_tags}"
}

#------------------------------------------------------
# Web service which required to listen a specific port
#------------------------------------------------------
resource "aws_ecs_service" "service" {
  count = "${var.service_app_port > 0 ? 1 : 0}"

  name                              = "${var.project_name}-${var.env}"
  cluster                           = "${var.ecs_cluster}"
  task_definition                   = "${aws_ecs_task_definition.service_server.arn}"
  desired_count                     = "${var.ecs_service_desired_count}"
  health_check_grace_period_seconds = "${var.health_check_grace_period_seconds}"

  load_balancer {
    target_group_arn  = "${var.target_group_arn}"
    container_name    = "${var.service_container_name}"
    container_port    = "${var.service_app_port}"
  }
  lifecycle {
    ignore_changes = ["task_definition"]
  }

  # no tagging feature supported for existing service with short arn, will not work even with opt-in
  # https://github.com/terraform-providers/terraform-provider-aws/issues/6481
}

#-----------------------------
# Background / Worker service
#-----------------------------
resource "aws_ecs_service" "service_background" {
  count = "${var.service_app_port > 0 ? 0 : 1}"

  name                              = "${var.project_name}-${var.env}"
  cluster                           = "${var.ecs_cluster}"
  task_definition                   = "${aws_ecs_task_definition.service_server.arn}"
  desired_count                     = "${var.ecs_service_desired_count}"

  lifecycle {
    ignore_changes = ["task_definition"]
  }

  # no tagging feature supported for existing service with short arn, will not work even with opt-in
  # https://github.com/terraform-providers/terraform-provider-aws/issues/6481
}

## Autoscaling
resource "aws_appautoscaling_target" "appautoscaling_target" {
  count              = "${var.ecs_service_autoscale_enabled? 1 : 0}"
  max_capacity       = "${var.autoscale_max_capacity}"
  min_capacity       = "${var.autoscale_min_capacity}"
  resource_id        = "service/${var.ecs_cluster}/${var.project_name}"
  role_arn           = "${var.ecs_autoscale_role_arn}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "ecs_service_cpu_autoscaling_policy" {
  name               = "scale-up-from-cpu-utilization"
  policy_type        = "TargetTrackingScaling"
  resource_id        = "${aws_appautoscaling_target.appautoscaling_target.resource_id}"
  scalable_dimension = "${aws_appautoscaling_target.appautoscaling_target.scalable_dimension}"
  service_namespace  = "${aws_appautoscaling_target.appautoscaling_target.service_namespace}"

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value            = 60
    scale_in_cooldown       = 300
    scale_out_cooldown      = 60
  }
}

resource "aws_appautoscaling_policy" "ecs_service_memory_autoscaling_policy" {
  name               = "scale-up-from-memory-utilization"
  policy_type        = "TargetTrackingScaling"
  resource_id        = "${aws_appautoscaling_target.appautoscaling_target.resource_id}"
  scalable_dimension = "${aws_appautoscaling_target.appautoscaling_target.scalable_dimension}"
  service_namespace  = "${aws_appautoscaling_target.appautoscaling_target.service_namespace}"

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }

    target_value            = 60
    scale_in_cooldown       = 300
    scale_out_cooldown      = 60
  }
}