module "ec2-private" {
  depends_on             = [module.vpc]
  source                 = "terraform-aws-modules/ec2-instance/aws"
  version                = "6.3.0"
  count                  = length(module.vpc.private_subnets)
  name                   = "${var.environment}-vm"
  ami                    = data.aws_ami.amzlinux2023.id
  instance_type          = var.instance_type
  key_name               = var.instance_keypair
  user_data              = file("${path.module}/app1-install.sh")
  tags                   = local.common_tags
  vpc_security_group_ids = [module.private_sg.security_group_id]
  subnet_id              = module.vpc.private_subnets[count.index]
}
