## Project
variable "env" {
  default = "test"
}
variable "project_name" {
  default = "test"
}
## ECS
variable "service_app_env_port" {
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
variable "ecs_service_desired_count" {
  default = 1
}
variable "target_group_arn" {
  default = ""
}
