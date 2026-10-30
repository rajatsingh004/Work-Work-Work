resource "aws_codedeploy_app" "this" {
  name             = var.application_name
  compute_platform = var.compute_platform
  tags             = var.tags
}

resource "aws_codedeploy_deployment_group" "this" {
  app_name               = aws_codedeploy_app.this.name
  deployment_group_name  = var.deployment_group_name
  service_role_arn       = var.service_role_arn
  deployment_config_name = var.deployment_config_name
  autoscaling_groups     = var.autoscaling_group_names
  tags                   = var.tags

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE", "DEPLOYMENT_STOP_ON_ALARM"]
  }

  deployment_style {
    deployment_type   = var.deployment_type
    deployment_option = var.deployment_option
  }

  dynamic "ec2_tag_set" {
    for_each = var.ec2_tag_filters == {} ? [] : [var.ec2_tag_filters]
    content {
      dynamic "ec2_tag_filter" {
        for_each = ec2_tag_set.value
        content {
          key   = ec2_tag_filter.key
          type  = "KEY_AND_VALUE"
          value = ec2_tag_filter.value
        }
      }
    }
  }
}
