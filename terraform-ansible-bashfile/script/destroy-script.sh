#!/bin/bash

cd terraform/
terraform destroy -target=module.vpc-module -target=module.ec2-module -auto-approve --var-file="terraform.tfvars"