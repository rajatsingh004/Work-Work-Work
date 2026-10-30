variable "cluster_name" { type = string }
variable "principal_arn" {
  type        = string
  description = "IAM role ARN for a human or group role; use short-lived role assumption."
}
variable "namespace" { type = string }
variable "permission_type" {
  type        = string
  description = "One of read, write, or read-write. Permissions are namespace-scoped."
  validation {
    condition     = contains(["read", "write", "read-write"], var.permission_type)
    error_message = "permission_type must be read, write, or read-write."
  }
}
variable "tags" {
  type    = map(string)
  default = {}
}
