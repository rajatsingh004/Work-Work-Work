variable "application_name" {
  type        = string
  description = "CodeDeploy application name."
}
variable "deployment_group_name" {
  type        = string
  description = "CodeDeploy group name."
}
variable "service_role_arn" {
  type        = string
  description = "CodeDeploy service role ARN."
}
variable "autoscaling_group_names" {
  type        = list(string)
  default     = []
  description = "ASGs associated with the deployment group."
}
variable "compute_platform" {
  type        = string
  default     = "Server"
  description = "CodeDeploy compute platform."
}
variable "deployment_config_name" {
  type        = string
  default     = "CodeDeployDefault.OneAtATime"
  description = "Deployment configuration."
}
variable "deployment_type" {
  type        = string
  default     = "IN_PLACE"
  description = "IN_PLACE or BLUE_GREEN; validate additional settings for blue/green."
}
variable "deployment_option" {
  type        = string
  default     = "WITHOUT_TRAFFIC_CONTROL"
  description = "Traffic control option supported by the selected deployment type."
}
variable "ec2_tag_filters" {
  type        = map(string)
  default     = {}
  description = "EC2 tag selectors for eligible targets."
}
variable "tags" {
  type        = map(string)
  default     = {}
  description = "Resource tags."
}
