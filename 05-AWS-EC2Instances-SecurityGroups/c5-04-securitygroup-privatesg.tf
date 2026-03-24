module "private_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.3.1"

  name        = "private-sg"
  description = "Secutiy Group with HTTP and SSH port open for entire VPC Block (IPv4 CIDR), egress ports are all opened."
  vpc_id      = module.vpc.vpc_id

  #Ingress Rules
  ingress_rules       = ["http-80-tcp", "ssh-22-tcp"]
  ingress_cidr_blocks = [module.vpc.vpc_cidr_block]

  #Egress Rules
  egress_rules = ["all-all"]

  tags = local.common_tags
}
