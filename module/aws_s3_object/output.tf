output "id" {
  value = aws_s3_object.object.acl
}


output "key" {
  value = aws_s3_object.object.key
}

output "metadata" {
  value = aws_s3_object.object.metadata
}