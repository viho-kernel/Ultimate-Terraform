module "myvpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "6.6.0" #Latest
  #VPC Basic Details
  name            = "vpc-dev"
  cidr            = "10.0.0.0/16"
  azs             = ["us-east-2a", "us-east-2b"]
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets = ["10.0.101.0/24", "10.0.102.0/24"]

  #database subnets
  #My database dont need any public connections via NAT or Internet Gateway
  create_database_subnet_group       = true
  create_database_subnet_route_table = true
  database_subnets                   = ["10.0.151.0/24", "10.0.152.0/24"]

  #Nat gateway for outbound communication.
  enable_nat_gateway = true

  #Having one nat gateway for costing
  single_nat_gateway = true

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

  tags = {
    owner       = "Vihari"
    Environment = "Dev"
  }

  vpc_tags = {
    Name = "vpc-dev"
  }

  
}
