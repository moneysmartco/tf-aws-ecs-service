# ECS Service
[![CircleCI](https://circleci.com/gh/moneysmartco/tf-aws-ecs-service.svg?style=svg&circle-token=xxx)](https://circleci.com/gh/moneysmartco/tf-aws-ecs-service)

Define ECS service and the dependent Task Definition inside an existing ECS cluster



## Important note
1) The state of Task Definition will drift once deployment from drone occurs.
2) Tagging of Task Definition will be applied only on the Task Definition arn that is tracked on terraform, which will not be the latest Task Definition once deployment from drone occurs.
3) Tagging of ECS service is only possible if executed on a brand new cluster, because of long arn format requirement. Please use [release v1.2](https://github.com/moneysmartco/tf-aws-ecs-service/tree/v1.2).
Otherwise, use [release v1.2.1](https://github.com/moneysmartco/tf-aws-ecs-service/tree/v1.2.1) for tagging of Task Definition only.

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
