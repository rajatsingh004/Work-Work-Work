output "application_name" {
  value = aws_codedeploy_app.this.name
}
output "deployment_group_id" {
  value = aws_codedeploy_deployment_group.this.id
}
output "deployment_group_arn" {
  value = aws_codedeploy_deployment_group.this.arn
}
