output "bastion_sg_arn" {
  description = "The ARN of the bastion security group ARN"
  value       = module.public_bastion_sg.security_group_arn

}

output "bastion_sg_id" {
  description = "The security group id of the bastion"
  value       = module.public_bastion_sg.security_group_id

}

output "bastion_vpc_id" {
  description = "The VPC ID where the bastion SG resides"
  value       = module.public_bastion_sg.security_group_vpc_id
}

output "bastion_sg_name" {
  description = "The name of the bastion security group"
  value       = module.public_bastion_sg.security_group_name
}

output "private_sg_arn" {
  description = "The ARN of the private security group ARN"
  value       = module.private_sg.security_group_arn

}

output "private_sg_id" {
  description = "The security group id of the bastion"
  value       = module.private_sg.security_group_id

}

output "private_vpc_id" {
  description = "The VPC ID where the private SG resides"
  value       = module.private_sg.security_group_vpc_id
}

output "private_sg_name" {
  description = "The name of the private security group"
  value       = module.private_sg.security_group_name
}
