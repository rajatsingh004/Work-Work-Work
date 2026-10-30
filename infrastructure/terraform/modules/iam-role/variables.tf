variable "name" {
  type        = string
  description = "Role name."
}
variable "principal_type" {
  type        = string
  default     = "Service"
  description = "IAM trust principal type."
}
variable "principal_identifiers" {
  type        = list(string)
  description = "Principals allowed to assume the role."
}
variable "policy_arns" {
  type        = list(string)
  default     = []
  description = "Explicitly reviewed managed policies."
}
variable "tags" {
  type        = map(string)
  default     = {}
  description = "Role tags."
}
