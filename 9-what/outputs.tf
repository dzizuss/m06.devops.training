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

output "ecs_load_balancer_dns" {
  description = "DNS name to reach the ECS service via the Application Load Balancer"
  value       = aws_lb.ecs.dns_name
}

output "ecs_cluster_name" {
  description = "Name of the ECS cluster hosting the application"
  value       = aws_ecs_cluster.ecs.name
}

output "ecs_service_name" {
  description = "Name of the ECS service managing the tasks"
  value       = aws_ecs_service.ecs.name
}
