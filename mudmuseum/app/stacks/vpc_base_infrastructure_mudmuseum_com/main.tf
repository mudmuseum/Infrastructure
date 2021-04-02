module "vpc_base_infrastructure_mudmuseum_com" {
  source                    = "../../modules/vpc_base_infra"

  vpc_tag_name              = "MudMuseum VPC."
  public_subnet_tag_name    = "MudMuseum Public Subnet."
  internet_gateway_tag_name = "MudMuseum Internet Gateway."
  route_table_tag_name      = "MudMuseum Routing Table."
}
