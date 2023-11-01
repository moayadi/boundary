variable "resource_name_prefix" {
    type = string
  
}

variable "region" {
  type = string
  default = "ap-southeast-1"
  
}

variable "lb_health_check_path" {
  type = string
}

variable "common_tags" {
    type = map(string)
}

variable "ssl_policy" {
  type        = string
  default     = "ELBSecurityPolicy-TLS-1-2-2017-01"
  description = "SSL policy to use on LB listener"
}

variable "public_subnet_tags" {
    type = map(string)
}

variable "private_subnet_tags" {
    type = map(string)
}

variable "allowed_inbound_cidrs_lb" {
  type        = list(string)
  description = "(Optional) List of CIDR blocks to permit inbound traffic from to load balancer"
  default     = null
}

variable "license" {
  type = string
  
}