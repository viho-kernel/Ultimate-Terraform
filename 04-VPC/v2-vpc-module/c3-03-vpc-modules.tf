module "myvpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "6.6.0" #Latest
  #VPC Basic Details
  name            = "${local.name}-${var.vpc_name}"
  cidr            = var.vpc_cidr_block
  azs             = var.vpc_availability_zones
  public_subnets  = var.vpc_public_subnets
  private_subnets = var.vpc_private_subnets

  #database subnets
  #My database dont need any public connections via NAT or Internet Gateway
  create_database_subnet_group       = var.vpc_create_database_subnet_group
  create_database_subnet_route_table = var.vpc_create_database_subnet_route_table
  database_subnets                   = var.vpc_database_subnets

  #Nat gateway for outbound communication.
  enable_nat_gateway = var.vpc_enable_nat_gateway

  #Having one nat gateway for costing
  single_nat_gateway = var.vpc_single_nat_gateway

  #VPC Dns parameter
  enable_dns_hostnames = true
  enable_dns_support   = true

  #tags
  public_subnet_tags = {
    Name = "public-subnets"
  }
  private_subnet_tags = {
    Name = "private-subnets"
  }

  database_subnet_tags = {

    Name = "database-subnets"
  }

  tags = local.common_tags

  vpc_tags = local.common_tags

}
