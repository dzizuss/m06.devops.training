output "instance_public_ip" {
  description = "The public IP address of the instance"
  value       = aws_instance.machine.public_ip
}

output "instance_private_ip" {
  description = "The private IP address of the instance"
  value       = aws_instance.machine.private_ip
}

output "instance_public_dns" {
  description = "The public DNS name of the instance"
  value       = aws_instance.machine.public_dns
}
