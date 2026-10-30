variable "name" {
  type        = string
  description = "Short application/environment identifier."
}
variable "vpc_id" {
  type        = string
  description = "VPC ID for the ALB and target group."
}
variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR permitted for target egress."
}
variable "subnet_ids" {
  type        = list(string)
  description = "ALB subnet IDs across at least two AZs."
}
variable "allowed_client_cidrs" {
  type        = list(string)
  description = "Explicit client CIDRs allowed to reach HTTPS."
}
variable "certificate_arn" {
  type        = string
  description = "ACM certificate ARN for the listener."
}
variable "target_port" {
  type        = number
  default     = 8080
  description = "Application target port."
}
variable "health_check_path" {
  type        = string
  default     = "/health"
  description = "Target health-check path."
}
variable "idle_timeout_seconds" {
  type        = number
  default     = 60
  description = "ALB connection idle timeout."
}
variable "internal" {
  type        = bool
  default     = false
  description = "Whether the ALB is internal."
}
variable "deletion_protection" {
  type        = bool
  default     = true
  description = "Enable ALB deletion protection."
}
variable "ssl_policy" {
  type        = string
  default     = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  description = "Approved listener TLS policy."
}
variable "tags" {
  type        = map(string)
  default     = {}
  description = "Resource tags."
}
