resource "null_resource" "name" {
  depends_on = [module.ec2_bastion_instance]

  connection {
    type = "ssh"
    host = aws_eip.bastion_ip.public_ip
    user = "ec2-user"

    password    = ""
    private_key = file("private-key/terraform-key.pem")

  }

  provisioner "file" {
    source      = "private-key/terraform-key.pem"
    destination = "/tmp/terraform-key.pem"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo chmod 400 /tmp/terraform-key.pem"
    ]
    on_failure = continue
  }
  provisioner "local-exec" {
    command     = "echo VPC created on `date` and VPC ID: ${module.vpc.vpc_id} >> creation-time-vpc-id.txt"
    working_dir = "local-exec-output-files/"
    on_failure  = continue
    when        = create #creation time provisioner.
  }

  provisioner "local-exec" {
    command     = "echo Destroy time prov `date` >> destroy-time-prov.txt"
    working_dir = "local-exec-output-files/"
    when        = destroy
    #on_failure = continue
  }
}
