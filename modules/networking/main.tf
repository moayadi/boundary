# data "aws_vpc" "selected" {
#   id = var.vpc_id
# }

data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
  # vpc_id = data.aws_vpc.selected.id
  tags   = var.private_subnet_tags
}


data "aws_subnets" "public" {
  # vpc_id = data.aws_vpc.selected.id
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
  tags   = var.public_subnet_tags
}
