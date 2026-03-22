output "public_ip" {
  description = "EC2 Instance Public IP"
  value       = aws_instance.main[*].public_ip
}

output "public-ip" {
  description = "EC2 Public ip"
  value       = [for instance in aws_instance.main : instance.public_ip]
}

output "public-dns" {
  description = "DNS of the instancs"
  value       = { for instance in aws_instance.main : instance.id => instance.public_dns }
}
output "public_dns" {
  value = { for k, v in aws_instance.main : k => v.public_dns }
}
