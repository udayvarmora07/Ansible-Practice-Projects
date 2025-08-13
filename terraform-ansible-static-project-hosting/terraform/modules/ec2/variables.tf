variable "vpc_id" {
  description = "vpc id"
  type        = string
}

variable "ec2_ami" {
  description = "ec2 ami image"
  type        = string
}

variable "instance_type" {
  description = "ec2 instance type"
  type        = string
}

variable "public_subnet_id" {
  description = "public subnet id"
  type        = string
}