output "s3_bucket_name" {
  value       = aws_s3_bucket.expense-tracker-backend-s3-bucket.id
  description = "The name of the S3 bucket"
}

output "dynamodb_table_name" {
  value       = aws_dynamodb_table.expense-tracker-backend-dynamodb-table-state-locking.id
  description = "The name of the DynamoDB table"
}