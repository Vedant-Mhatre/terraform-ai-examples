output "alb_dns_name" {
  description = "Public DNS name for the inference endpoint ALB."
  value       = aws_lb.this.dns_name
}

output "ecs_cluster_name" {
  description = "ECS cluster name running GPU workloads."
  value       = aws_ecs_cluster.this.name
}

output "ecs_service_name" {
  description = "ECS service name for inference."
  value       = aws_ecs_service.inference.name
}
