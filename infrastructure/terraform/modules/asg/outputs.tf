output "asg_name" {
  value = aws_autoscaling_group.this.name
}
output "asg_arn" {
  value = aws_autoscaling_group.this.arn
}
output "launch_template_id" {
  value = aws_launch_template.this.id
}
output "instance_role_arn" {
  value = aws_iam_role.instance.arn
}
output "instance_security_group_id" {
  value = aws_security_group.instance.id
}
