variable "aws_region" {
  description = "AWS region to deploy resources into"
  type        = string
  default     = "ap-southeast-1"
}

variable "azs" {
  description = "availability zones to use in AWS region"
  type        = list(string)
  default = [
    "ap-southeast-1a",
    "ap-southeast-1b",
    "ap-southeast-1c",
  ]
}

variable "common_tags" {
  type        = map(string)
  description = "Tags for VPC resources"
}

variable "resource_name_prefix" {
  description = "Prefix for resource names (e.g. \"prod\")"
  type        = string
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default = [
    "10.0.0.0/19",
    "10.0.32.0/19",
    "10.0.64.0/19",
  ]
}

variable "private_subnet_tags" {
  type        = map(string)
  description = "Tags for private subnets. Be sure to provide these tags to the Vault installation module."
}

variable "public_subnet_tags" {
  type        = map(string)
  description = "Tags for private subnets. Be sure to provide these tags to the Load Balancer module."
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default = [
    "10.0.128.0/20",
    "10.0.144.0/20",
    "10.0.160.0/20",
  ]
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}
