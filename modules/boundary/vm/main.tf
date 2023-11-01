data "aws_ami" "ubuntu" {
  count       = var.user_supplied_ami_id != null ? 0 : 1
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

data "aws_ami" "amazonlinux" {
  count       = var.user_supplied_ami_id != null ? 0 : 1
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["amazon"] # Canonical
}


module "incoming" {
  source      = "terraform-aws-modules/security-group/aws"
  name        = "${var.resource_name_prefix}-incoming-sg"
  description = "inbound sg"
  vpc_id      = var.vpc_id

  ingress_rules       = ["ssh-tcp"]
  ingress_cidr_blocks = ["0.0.0.0/0"]

  egress_rules       = ["all-all"]
  egress_cidr_blocks = ["0.0.0.0/0"]
  tags = var.common_tags
}


resource "aws_instance" "controller" {
  subnet_id            = var.subnet_id
  ami                  = var.user_supplied_ami_id != null ? var.user_supplied_ami_id : data.aws_ami.ubuntu[0].id
  instance_type        = var.instance_type
  key_name             = var.key_name != null ? var.key_name : null
  user_data            = var.userdata_script
  iam_instance_profile = aws_iam_instance_profile.instance_profile.name
  vpc_security_group_ids = [
    module.incoming.security_group_id
  ]
  

  ebs_block_device {
    device_name           = "/dev/sda1"
    volume_type           = "gp3"
    volume_size           = 100
    throughput            = 150
    iops                  = 3000
    delete_on_termination = true
  }

  tags = {
    Name = "${var.resource_name_prefix}-${var.application}"
  }

}


resource "aws_lb_target_group_attachment" "controller" {
  target_group_arn = var.target_group_arn
  target_id = aws_instance.controller.id
  port = 9200
  
}

