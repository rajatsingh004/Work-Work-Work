# Capacity Watch Lambda

The ASG and ECS message handlers in the source repo observed scaling state, sent a consolidated SNS notification, and started a Step Functions workflow when capacity was still pending. This combined handler keeps that operational pattern while moving resource lists and integration ARNs to the event/environment.

The response is an observation, not an availability guarantee. Use CloudWatch/EventBridge schedules with bounded concurrency and alert on repeated transitions. IAM needs read-only ASG/ECS describe actions plus optional `sns:Publish` and `states:StartExecution` permissions.
