variable "account_ids" {
  description = "List of AWS account IDs to enable Inspector2 for"
  type        = list(string)
}

variable "resource_types" {
  description = "List of resource types to enable for Inspector2"
  type        = list(string)
  default     = ["ECR", "EC2"]
}
