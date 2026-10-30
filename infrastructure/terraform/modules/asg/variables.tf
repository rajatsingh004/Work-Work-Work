variable "name" {
  type        = string
  description = "ASG and resource prefix."
}
variable "vpc_id" {
  type        = string
  description = "VPC for the ASG security group."
}
variable "subnet_ids" {
  type        = list(string)
  description = "Private subnet IDs across AZs."
}
variable "alb_security_group_id" {
  type        = string
  description = "Only source allowed to reach the app port."
}
variable "target_group_arns" {
  type        = list(string)
  default     = []
  description = "ALB target group ARNs."
}
variable "ami_id" {
  type        = string
  description = "Approved, patched AMI ID for the selected region."
}
variable "default_instance_type" {
  type        = string
  default     = "m7i.large"
  description = "Launch-template default instance type."
}
variable "instance_type_priority" {
  type        = list(string)
  default     = ["m7i.large", "m6i.large"]
  description = "Compatible alternatives for mixed instances."
}
variable "application_port" {
  type        = number
  default     = 8080
  description = "Application listener port."
}
variable "min_size" {
  type        = number
  default     = 2
  description = "Minimum group size."
}
variable "max_size" {
  type        = number
  default     = 6
  description = "Maximum group size."
}
variable "desired_capacity" {
  type        = number
  default     = 2
  description = "Initial desired group size."
}
variable "on_demand_base_capacity" {
  type        = number
  default     = 2
  description = "Minimum on-demand capacity."
}
variable "on_demand_percentage" {
  type        = number
  default     = 100
  description = "On-demand percentage above the base."
}
variable "instance_policy_arns" {
  type        = list(string)
  default     = ["arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore", "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"]
  description = "Managed policies reviewed for the workload."
}
variable "user_data" {
  type        = string
  default     = ""
  description = "Optional bootstrap script; do not pass secrets."
}
variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags propagated to instances and volumes."
}
