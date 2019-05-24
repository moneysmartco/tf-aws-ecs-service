[
    {
        "dnsSearchDomains": null,
        "logConfiguration": {
            "logDriver": "syslog",
            "options": {
                "syslog-address": "tcp://127.0.0.1:601"
            }
        },
        "entryPoint": null,
        "command": %{ if service_container_cmd == "" }null%{ else }${jsonencode(split(" ", service_container_cmd))}%{ endif },
        "portMappings": [
            {
                "hostPort": 0,
                "protocol": "tcp",
                "containerPort": ${port}
            }
        ],
        "command": null,
        "linuxParameters": null,
        "cpu": ${service_server_cpu},
        "environment": [],
        "ulimits": null,
        "dnsServers": null,
        "mountPoints": [],
        "workingDirectory": null,
        "dockerSecurityOptions": null,
        "memory": ${service_server_memory},
        "memoryReservation": null,
        "volumesFrom": [],
        "image": "${service_server_docker_image}",
        "disableNetworking": null,
        "essential": true,
        "links": null,
        "hostname": null,
        "extraHosts": null,
        "user": null,
        "readonlyRootFilesystem": null,
        "dockerLabels": null,
        "privileged": null,
        "name": "${service_container_name}"
    }
]

