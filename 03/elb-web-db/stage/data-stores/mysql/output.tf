output "address" {
  value       = aws_db_instance.mydbInstance.address
  description = "DB address"
}

output "port" {
  value       = aws_db_instance.mydbInstance.port
  description = "DB port"
}
