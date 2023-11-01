output "controller" {
  value = format("aws ssm start-session --target %s", module.controller.instance_id)
}