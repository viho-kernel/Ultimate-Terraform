module "public_bastion_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.3.1"

  name        = "public-bastion-sg"
  description = "Secutiy Group with SSH port open for everyone (IPv4 CIDR), egress ports are all opened."
  vpc_id      = module.vpc.vpc_id

  #Ingress Rules
  ingress_rules       = ["ssh-tcp"]
  ingress_cidr_blocks = ["0.0.0.0/0"]

  #Egress Rules
  egress_rules = ["all-all"]

  tags = local.common_tags
}
