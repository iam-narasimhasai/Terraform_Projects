module "VPC" {
  source     = "./VPC"
  cidr_block = var.cidr_block
  availability_zone = var.availability_zone
}

module "DB" {
  source = "./DB"
  subnetids = [ module.VPC.aws_private_subnet[2].id , module.VPC.aws_private_subnet[3].id ]
  
}