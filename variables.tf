## Project
variable "env" {
  default = "test"
}
variable "project_name" {
  default = "test"
}
## ECS
variable "service_container_name" {
  default = "container-name"
}
variable "service_container_cmd" {
  description = "Command to start container (follow Dockerfile's CMD by default)"
  default = ""
}
variable "service_app_port" {
  default = 3000
}
variable "service_server_cpu" {
  default = 128
}
variable "service_server_memory" {
  default = 128
}
variable "task_required_cpu" {
  default = 128
}
variable "task_required_memory" {
  default = 128
}
variable "service_server_docker_image" {
  default = "xxx.dkr.ecr.ap-southeast-1.amazonaws.com/service-server:latest"
}
variable "health_check_grace_period_seconds" {
  default = 0
}

variable "ecs_cluster" {
  default = "ecs-cluster-name"
}
variable "ecs_service_desired_count" {
  default = 1
}

variable "target_group_arn" {
  default = ""
}
variable "depends_on_target_group_attachment" {
  description = "A place holder to wait for the target group from other module to be available"
  default = ""
}

variable "tags" {
  description = "Tagging resources with default values"
  default = {
    "Name" = ""
    "Country" = ""
    "Environment" = ""
    "Repository" = ""
    "Owner" = ""
    "Department" = ""
    "Team" = "shared"
    "Product" = "common"
    "Project" = "common"
    "Stack" = ""
  }
}

## Service autoscaling
variable "ecs_service_autoscale_enabled" {
  default = false
}

variable "ecs_autoscale_role_arn" {
  description = "ECS IAM role to be used for autoscaling"
  default = ""
}

variable "autoscale_max_capacity" {
  default = 10
}

variable "autoscale_min_capacity" {
  default = 2
}

variable "ecs_service_cpu_autoscale_policy_enabled" {
  default = false
}
variable "ecs_cpu_autoscale_target_value" {
  default = 60
}

variable "ecs_cpu_autoscale_scale_in_cooldown" {
  default = 300
}

variable "ecs_cpu_autoscale_scale_out_cooldown" {
  default = 60
}
variable "ecs_memory_autoscale_target_value" {
  default = 60
}

variable "ecs_memory_autoscale_scale_in_cooldown" {
  default = 300
}

variable "ecs_memory_autoscale_scale_out_cooldown" {
  default = 60
}


variable "ecs_service_memory_autoscale_policy_enabled" {
  default = false
}
