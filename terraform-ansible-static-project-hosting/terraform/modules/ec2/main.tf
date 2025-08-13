locals {
  inbound_ports = [22, 80]
}

resource "aws_key_pair" "key_pair" {
  key_name   = "ec2-rsa"
  public_key = file("~/.ssh/ec2_rsa.pub")
}

resource "aws_security_group" "ec2-sg" {
  description = "allows ssh and http"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = local.inbound_ports

    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# resource "aws_instance" "instance" {
#   ami = var.ec2_ami
#   instance_type = var.instance_type
#   key_name = aws_key_pair.key_pair.key_name
#   subnet_id = var.public_subnet_id
#   vpc_security_group_ids = [ aws_security_group.ec2-sg.id ]
#   associate_public_ip_address = true

#   tags = {
#     "Name" = "public-ec2-uday-1"
#   }
# }

resource "aws_instance" "instance" {
  ami                         = var.ec2_ami
  count                       = 2
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.key_pair.key_name
  subnet_id                   = var.public_subnet_id
  vpc_security_group_ids      = [aws_security_group.ec2-sg.id]
  associate_public_ip_address = true

  tags = {
    "Name" = "public-ec2-uday-${count.index}"
  }
}

resource "local_file" "file" {
  content    = join("\n", aws_instance.instance[*].public_ip, ["[all:vars]\nansible_ssh_private_key_file=/home/uday/.ssh/ec2_rsa"])
  filename   = "/home/uday/Ansible/terraform-ansible-static-project-hosting/ansible/inventory/hosts.ini"
  depends_on = [aws_instance.instance]
}

resource "null_resource" "nr" {
  depends_on = [aws_instance.instance, local_file.file]

  provisioner "local-exec" {
    command = <<-EOT
      sleep 30
      ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i /home/uday/Ansible/terraform-ansible-static-project-hosting/ansible/inventory/hosts.ini /home/uday/Ansible/terraform-ansible-static-project-hosting/ansible/static-web-hosting.yml
    EOT
  }
}