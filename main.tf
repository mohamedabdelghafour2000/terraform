provider "aws" {
  profile = var.profile
  region  = var.region
}

module "myvpc" {
  source        = "./modules/myvpc"
  vpc_cidr      = var.vpc_cidr
  nat_subnet_id = module.mysubnet.public_subnets_id[0]
}

module "mysubnet" {
  source       = "./modules/mysubnet"
  vpc_id       = module.myvpc.vpc_id
  pub_subnets  = var.pub_subnet
  priv_subnets = var.priv_subnet
  igw_id       = module.myvpc.igw_id
  nat_id       = module.myvpc.nat_id
}

module "loadBlanacer" {
  source         = "./modules/loadBlanacer"
  lb_vpc_id      = module.myvpc.vpc_id
  pub_target_id  = module.myec2.public_ec2_id
  priv_target_id = module.myec2.private_ec2_id
  lb_internal    = var.lb_internal
  lb_subnets     = [module.mysubnet.public_subnets_id,module.mysubnet.private_subnets_id]                   
  lb_sg_id       = module.myec2.security_group_id
}

module "myec2" {
  source                = "./modules/myec2"
  sg_vpc_id             = module.myvpc.vpc_id
  priv_lb_dns           = module.loadBlanacer.private_load_balancer_dns
  ec2_public_subnet_id  = module.mysubnet.public_subnets_id
  ec2_private_subnet_id = module.mysubnet.private_subnets_id
}

output "public_lb_ip" {
    value = module.loadBlanacer.public_load_balancer_dns
}