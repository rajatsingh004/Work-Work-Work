# ASG Scaling Lambda

This handler applies a batch of Auto Scaling Group capacity changes, preserves omitted settings from the current group configuration, returns the effective values, and optionally publishes an SNS summary or starts a Step Functions execution. It builds on the original operational pattern of notifying operators and coordinating follow-up after scaling.

## Contract

`event.example.json` shows the input. `min_size`, `max_size`, and `desired_capacity` are optional per operation; omitted values are read from the current group. Bounds and desired capacity are validated before the update call. Configure optional `SNS_TOPIC_ARN` and `STEP_FUNCTION_ARN` only when those integrations are needed.

## IAM and deployment

Use a Lambda execution role with `autoscaling:DescribeAutoScalingGroups` and `autoscaling:UpdateAutoScalingGroup` scoped to the target group ARNs. Add `sns:Publish` on the one notification topic and `states:StartExecution` on the one state machine only when configured. Provision the Lambda and IAM role with IaC; do not add access keys to environment variables.

The scaling API acceptance is not proof that instances are healthy. A downstream state machine or monitor should verify instance lifecycle and target health before declaring completion.
