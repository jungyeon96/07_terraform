output "alb_dnsname" {
  value       = "http://${aws_lb.myALB.dns_name}"
  description = "myALB DNS name"
}
