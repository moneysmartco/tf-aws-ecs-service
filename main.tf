data "template_file" "service_server_container_definition" {
  template = "${file("${path.module}/task-definition.json.tpl")}"
  vars {
    port                        = "${var.service_app_port}"
    service_server_cpu          = "${var.service_server_cpu}"
    service_server_memory       = "${var.service_server_memory}"
    service_server_docker_image = "${var.service_server_docker_image}"
  }
}

resource "aws_ecs_task_definition" "service_server" {
  family                = "${var.project_name}-${var.env}"
  cpu                   = "${var.task_required_cpu}"
  memory                = "${var.task_required_memory}"
  container_definitions = "${data.template_file.service_server_container_definition.rendered}"
}

resource "aws_ecs_service" "service" {
  name            = "${var.project_name}-${var.env}"
  cluster         = "${var.ecs_cluster}"
  task_definition = "${aws_ecs_task_definition.service_server.arn}"
  desired_count   = "${var.ecs_service_desired_count}"
  load_balancer {
    target_group_arn  = "${var.target_group_arn}"
    container_name    = "${var.service_container_name}"
    container_port    = "${var.service_app_port}"
  }
}
