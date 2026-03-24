module "ec2_bastion_instance" {
  source                 = "terraform-aws-modules/ec2-instance/aws"
  version                = "6.3.0"
  name                   = "${local.name}-BastionHost"
  ami                    = data.aws_ami.amzlinux2023.id
  key_name               = var.instance_keypair
  instance_type          = var.instance_type
  monitoring             = true
  vpc_security_group_ids = [module.public_bastion_sg.security_group_id]
  subnet_id              = module.vpc.public_subnets[0]
  tags                   = local.common_tags
}
