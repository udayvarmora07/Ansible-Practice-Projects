module "iam-module" {
  source        = "./modules/iam"
  iam_user_name = "test-user-uday"
}

module "vpc-module" {
  source                    = "./modules/vpc"
  vpc_cidr_block            = var.vpc_cidr_block
  public_subnet_cidr_block  = "12.0.1.0/24"
  private_subnet_cidr_block = "12.0.2.0/24"
}

module "ec2-module" {
  source           = "./modules/ec2"
  vpc_id           = module.vpc-module.vpc_id
  ec2_ami          = var.ec2_ami
  instance_type    = var.instance_type
  public_subnet_id = module.vpc-module.public_subnet_id
}
