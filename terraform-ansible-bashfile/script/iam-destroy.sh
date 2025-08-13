#!/bin/bash

cd terraform/
terraform destroy -target=module.iam-module -auto-approve --var-file="terraform.tfvars"