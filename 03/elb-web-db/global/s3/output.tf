output "s3_bucket_arn" {
  value       = aws_s3_bucket.myS3_remote_state.arn
  description = "S3 Bucket ARN"
}

output "dynamodb_table_name" {
  value       = aws_dynamodb_table.myDyDB_remote_state.id
  description = "DynamoDB Table Name"
}
