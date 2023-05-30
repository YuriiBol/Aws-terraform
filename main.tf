module "Vpc" {
    source                    = "./modules/Vpc"
    vpc_cidr_block            = var.vpc_cidr_block
    public_subnet_1_cidr      = var.public_subnet_1_cidr
    public_subnet_2_cidr      = var.public_subnet_2_cidr
    private_subnet_1_cidr     = var.private_subnet_1_cidr
    private_subnet_2_cidr     = var.private_subnet_2_cidr
    database_subnet_1_cidr    = var.database_subnet_1_cidr
    database_subnet_2_cidr    = var.database_subnet_2_cidr
}

module "Nat_gateway" {
    source                    = "./modules/Nat_gateway"
    public_subnet_1_id        = module.Vpc.public_subnet_1_id
    public_subnet_2_id        = module.Vpc.public_subnet_2_id
    private_subnet_1_id       = module.Vpc.private_subnet_1_id
    database_subnet_1_id      = module.Vpc.database_subnet_1_id    
    private_subnet_2_id       = module.Vpc.private_subnet_2_id
    database_subnet_2_id      = module.Vpc.database_subnet_2_id  
    vpc_id                    = module.Vpc.vpc_id
  depends_on = [
    module.Vpc
  ]
}
module "Security_group" {
    source                    = "./modules/Security_group"
    vpc_id                    = module.Vpc.vpc_id
    environment               = var.environment
    ssh_location              = var.ssh_location
}

module "acm_certificate" {
  source = "./modules/Certificate"
  subdomain_name = var.subdomain_name
  domain_name    = var.domain_name 
}
module "application_load_balancer" {
  source = "./modules/App-loadbalancer"
  environment               = var.environment
  alb_security_group_id     = module.security_groups.alb_security_group_id
  public_subnet_1_id        = module.Vpc.public_subnet_1_id
  public_subnet_2_id        = module.Vpc.public_subnet_2_id
  vpc_id                    = module.Vpc.vpc_id
  acm_certificate_arn       = module.Certificate.acm_certificate_arn
}

module "Ecr" {
  source = "./modules/Ecr"
}