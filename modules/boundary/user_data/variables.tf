variable "aws_region" {
  type        = string
  description = "AWS region where Vault is being deployed"
}

variable "resource_name_prefix" {
  type        = string
  description = "Resource name prefix used for tagging and naming AWS resources"
}


variable "num" {
  type = number
}

variable "secrets_manager_arn" {
  type = string
}

variable "controller_lb_dns" {
  type = string
  
}

variable "worker_auth_kms" {
  type = string
}

variable "bsr_kms" {
  type = string
}

variable "root_kms" {
  type = string
}

variable "recovery_kms" {
  
  type = string
}

variable "postgresql_connection_string" {
  type = string
}