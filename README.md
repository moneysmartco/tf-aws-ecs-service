# ECS Service
[![CircleCI](https://circleci.com/gh/moneysmartco/tf-aws-ecs-service.svg?style=svg&circle-token=xxx)](https://circleci.com/gh/moneysmartco/tf-aws-ecs-service)

Define ECS service inside an existing ECS cluster

Tagging of ECS service is only possible if creating a brand new cluster, please use release v1.2.1.
Otherwise, use release v1.2 for tagging on task definition only.

## Run with terraform

Update necessary variables and settings in terraform.tfvars following the sample file.

```
## Init the project
terraform init

## Download all remote modules
terrafrom get

## Prepare the output and verify
terraform plan

## Apply to AWS
terraform apply
```
