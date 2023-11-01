locals {
  user_data = templatefile("${path.module}/templates/install_boundary_contoller.sh.tpl",
    {
      TYPE = "controller"
      NAME = "boundary"
      region = var.aws_region
      secrets_manager_arn=var.secrets_manager_arn
      count=var.num
      controller_lb_dns=var.controller_lb_dns
      worker_auth_kms=var.worker_auth_kms
      bsr_kms=var.worker_auth_kms
      root_kms=var.worker_auth_kms
      recovery_kms=var.worker_auth_kms
      postgresql_connection_string=var.postgresql_connection_string




    }
  )
}
