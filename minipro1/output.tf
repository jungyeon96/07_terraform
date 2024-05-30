output "myDockerIP" {
  value       = aws_instance.myDocker.public_ip
  description = "EC2 Public IP"
}
