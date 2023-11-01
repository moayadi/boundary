module "vpc" {
    source = "./modules/aws-vpc"
    aws_region = "ap-southeast-1"
    common_tags = {demo = "boundary", owner = "moayad"}
    public_subnet_tags = var.public_subnet_tags
    private_subnet_tags = var.private_subnet_tags
    resource_name_prefix = var.resource_name_prefix
}


module "tls" {
  source = "./modules/tls"
  aws_region = "ap-southeast-1"
  resource_name_prefix = var.resource_name_prefix
  license = var.license
}

module "networking" {
  source = "./modules/networking"

  private_subnet_tags = var.private_subnet_tags
  public_subnet_tags  = var.public_subnet_tags
  vpc_id              = module.vpc.vpc_id
}

module "loadbalancer" {
  source = "./modules/aws-alb"

  allowed_inbound_cidrs = var.allowed_inbound_cidrs_lb
  common_tags           = var.common_tags
  lb_certificate_arn    = module.tls.lb_certificate_arn
  lb_health_check_path  = var.lb_health_check_path
  # lb_subnets            = module.networking.vault_subnet_ids
  lb_subnets           = module.networking.public_subnet_ids
  resource_name_prefix = var.resource_name_prefix
  ssl_policy           = var.ssl_policy
  vpc_id               = module.vpc.vpc_id
}


resource "random_id" "root_kms" {
  byte_length = 32
}

resource "random_id" "recovery_kms" {
  byte_length = 32
}

resource "random_id" "worker_auth_kms" {
  byte_length = 32
}
resource "random_id" "bsr_kms" {
  byte_length = 32
}



module "user_data" {
  source = "./modules/boundary/user_data"
  aws_region = "ap-southeast-1"
  bsr_kms = random_id.bsr_kms.b64_std
  controller_lb_dns = module.loadbalancer.lb_dns_name
  postgresql_connection_string = "http://"
  recovery_kms = random_id.recovery_kms.b64_std
  resource_name_prefix = var.resource_name_prefix
  secrets_manager_arn = module.tls.secrets_manager_arn
  worker_auth_kms = random_id.worker_auth_kms.b64_std
  root_kms = random_id.root_kms.b64_std
  num = 1
 
}

module "controller" {
  source = "./modules/boundary/vm"
  application = "controller"
  common_tags = var.common_tags
  instance_type = "t3.xlarge"
  key_name = "moayadkeypair"
  resource_name_prefix = var.resource_name_prefix
  vpc_id = module.vpc.vpc_id
  subnet_id = module.networking.private_subnet_ids[0]
  secrets_manager_arn = module.tls.secrets_manager_arn
  target_group_arn = module.loadbalancer.target_group_arn
  userdata_script = module.user_data.userdata_base64_encoded
}