resource "aws_instance" "main" {
  ami = data.aws_ami.ami.id
  #instance_type          = var.instance_type
  #instance_type          = var.instance_type_list[0]
  instance_type          = var.instance_type_map["dev"]
  user_data              = file("${path.module}/app1-install.sh")
  key_name               = var.instance_keypair
  vpc_security_group_ids = [data.aws_security_group.sg.id]
  count                  = 3
  tags = {
    "name" = "EC2-Instance-${count.index}"
  }
}
