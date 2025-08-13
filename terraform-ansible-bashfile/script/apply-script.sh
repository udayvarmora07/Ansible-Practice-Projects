#!/bin/bash

cd terraform/
terraform init
terraform apply -target=module.vpc-module -target=module.ec2-module -auto-approve --var-file="terraform.tfvars"

terraform output -json > /home/uday/Ansible/terraform-ansible-bashfile/ansible/inventory/outputs.json
sudo apt install jq -y
jq -r ".instance_ips.value[]" /home/uday/Ansible/terraform-ansible-bashfile/ansible/inventory/outputs.json | awk '{print $1}' > /home/uday/Ansible/terraform-ansible-bashfile/ansible/inventory/hosts.ini

cd ../ansible
sleep 30
ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i /home/uday/Ansible/terraform-ansible-bashfile/ansible/inventory/hosts.ini -u ubuntu --private-key /home/uday/.ssh/ec2_rsa /home/uday/Ansible/terraform-ansible-bashfile/ansible/static-web-hosting.yml