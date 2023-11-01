resource "aws_iam_instance_profile" "instance_profile" {
  name_prefix = "${var.resource_name_prefix}-${var.application}"
  role        = aws_iam_role.instance_role.name
}

resource "aws_iam_role" "instance_role" {
  name_prefix        = "${var.resource_name_prefix}-${var.application}"
  assume_role_policy = data.aws_iam_policy_document.instance_role.json
}

data "aws_iam_policy_document" "instance_role" {
  statement {
    effect = "Allow"
    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}


resource "aws_iam_role_policy" "policy" {

  name   = "${var.resource_name_prefix}-${var.application}-policy"
  role   = aws_iam_role.instance_role.id
  policy = data.aws_iam_policy_document.policy.json
}

data "aws_iam_policy_document" "policy" {
  statement {
    effect = "Allow"

    actions = [
      "ec2:DescribeInstances",
      "s3:*"
    ]

    resources = [
      "*",
    ]
  }
}

resource "aws_iam_role_policy" "session_manager" {
  name   = "${var.resource_name_prefix}-${var.application}-ssm"
  role   = aws_iam_role.instance_role.id
  policy = data.aws_iam_policy_document.session_manager.json
}

data "aws_iam_policy_document" "session_manager" {
  statement {
    effect = "Allow"

    actions = [
      "ssm:UpdateInstanceInformation",
      "ssmmessages:CreateControlChannel",
      "ssmmessages:CreateDataChannel",
      "ssmmessages:OpenControlChannel",
      "ssmmessages:OpenDataChannel"
    ]

    resources = [
      "*",
    ]
  }
}

resource "aws_iam_role_policy" "secrets_manager" {
  name   = "${var.resource_name_prefix}-${var.application}-sm"
  role   = aws_iam_role.instance_role.id
  policy = data.aws_iam_policy_document.secrets_manager.json
}

data "aws_iam_policy_document" "secrets_manager" {
  statement {
    effect = "Allow"

    actions = [
      "secretsmanager:GetSecretValue",
    ]

    resources = [
      var.secrets_manager_arn,
    ]
  }
}

