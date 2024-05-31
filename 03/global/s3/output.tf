output "s3_remote_state" {
  value       = aws_s3_bucket.remote_state.arn
  description = "S3 bucket remote state ARN"
}
