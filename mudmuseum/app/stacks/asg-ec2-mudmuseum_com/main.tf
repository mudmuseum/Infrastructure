module "ec2-1-mudmuseum_com" {
  source                        = "../../modules/asg-lc-ec2"

  lc_name                       = var.lc_name
  root_block_device_volume_size = var.root_block_device_volume_size
  root_block_device_volume_type = var.root_block_device_volume_type
  key_name                      = <%= output("key-pair-ec2-mudmuseum_com.key_name") %>
  security_group_id             = <%= output("security-group-mudmuseum_com.id") %>

  asg_name                      = var.asg_name
  image_id                      = var.image_id
  instance_type                 = var.instance_type

  desired_capacity              = "0"
  min_size                      = "0"
  max_size                      = "0"

  associate_public_ip_address   = true
}
