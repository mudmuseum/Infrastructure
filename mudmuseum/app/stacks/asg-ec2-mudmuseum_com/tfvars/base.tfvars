key_name          = <%= output('key-pair-ec2-mudmuseum_com.key_name') %>
security_group_id = <%= output('security-group-mudmuseum_com.id') %>
subnet_id         = <%= output('vpc_base_infrastructure_mudmuseum_com.public_subnet_id') %>
