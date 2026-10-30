variable "name" {
  type        = string
  description = "VPC name prefix."
}
variable "cidr" {
  type        = string
  description = "Non-overlapping VPC CIDR range."
}
variable "availability_zones" {
  type        = list(string)
  description = "At least two valid availability zones."
}
variable "public_subnets" {
  type        = list(string)
  default     = []
  description = "Public subnets for approved ingress/egress tiers."
}
variable "private_subnets" {
  type        = list(string)
  description = "Private application subnets."
}
variable "database_subnets" {
  type        = list(string)
  default     = []
  description = "Isolated database subnet ranges."
}
variable "single_nat_gateway" {
  type        = bool
  default     = true
  description = "Use one NAT gateway for a lower-cost non-production lab."
}
variable "tags" {
  type        = map(string)
  default     = {}
  description = "Consistent ownership and environment tags."
}
