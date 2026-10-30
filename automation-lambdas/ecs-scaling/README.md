# ECS Scaling Lambda

This function represents the ECS scale-up automation. It validates each requested service and capacity range, updates Application Auto Scaling's scalable target, sets the ECS service desired count, and optionally notifies via SNS or launches a Step Functions follow-up.

The handler reports an accepted API change; it does not claim tasks reached `RUNNING`. Validate deployment state, task placement, and service events as a separate completion step. Use an execution role limited to the named cluster/service resources and optional SNS topic/state machine.
