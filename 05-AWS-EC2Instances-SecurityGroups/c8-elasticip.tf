resource "aws_eip" "bastion_ip" {
  depends_on = [module.ec2_bastion_instance, module.vpc]
  tags       = local.common_tags

  instance = module.ec2_bastion_instance.id
  domain   = "vpc"

  provisioner "local-exec" {
    command     = "echo Destroy time prov `date` >> destroy-time-prov.txt"
    working_dir = "local-exec-output-files/"
    when        = destroy #deletion time provisioner.
  }

}
