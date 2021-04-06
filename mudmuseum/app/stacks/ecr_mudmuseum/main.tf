module "ecr_mudmuseum" {
  source = "../../modules/elastic_container_registry"

  name   = "mudmuseum"
}
