provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source                 = "terraform-aws-modules/vpc/aws"
  version                = "5.1.2"
  name                   = "${var.resource_name_prefix}-demo"
  cidr                   = var.vpc_cidr
  azs                    = var.azs
  enable_nat_gateway     = true
  single_nat_gateway     = true
    enable_dns_hostnames = true
  private_subnets        = var.private_subnet_cidrs
  public_subnets         = var.public_subnet_cidrs

  tags = var.common_tags

  private_subnet_tags = var.private_subnet_tags
  public_subnet_tags  = var.public_subnet_tags
}
