output "public_ip" {
  value       = aws_instance.example.public_ip
  description = "EC2 공인 IP"
}

output "public_dns" {
  value       = aws_instance.example.public_dns
  description = "EC2 DNS 이름"
}
