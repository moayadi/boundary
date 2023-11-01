output "userdata_base64_encoded" {
  value = base64encode(local.user_data)
}
