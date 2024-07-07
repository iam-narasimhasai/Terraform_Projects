module "network" {
  source = "./network"

  cidr_block = var.cidr_block
  availability_zoneslist = var.availability_zones
}


module "compute" {
  source = "./compute"
  vpc_id = module.network.webservervpcid
  public_subnetsid = module.network.public_subnetsid
  private_subnetsid = module.network.private_subnetsid
  image_id = var.image_id
  instance_type = var.instance_type 
}