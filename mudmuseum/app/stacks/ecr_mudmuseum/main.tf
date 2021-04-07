module "ecr_mudmuseum" {
  source = "../../modules/elastic_container_registry"

  names  = [ "rom-2.4.b4",
             "dystopiagold" ]
}
