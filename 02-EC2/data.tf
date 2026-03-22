data "aws_security_group" "sg" {
  filter {
    name   = "group-name"
    values = ["VPC-ssh"]
  }
}

data "aws_ami" "ami" {
  most_recent = true
  owners      = ["137112412989"]


  filter {
    name   = "name"
    values = ["al2023-ami-2023.10.20260302.1-kernel-6.1-x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_availability_zones" "zones" {
  state = "available"
}
