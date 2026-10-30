# CI/CD Engineering: Jenkins, CodeDeploy, SonarQube, and Checkmarx

The original pipeline material covered migrations to a shared Jenkins service, environment-aware deployments, tests, SonarQube, Checkmarx, and AWS CodeDeploy. This folder turns those requirements into a reusable declarative Jenkins pipeline instead of exposing an internal pipeline or SCM address.

## Pipeline stages

1. Clean workspace and validate parameters.
2. Checkout the selected branch or tag from the configured SCM credential.
3. Build the application artifact and optionally run unit tests.
4. Run SonarQube analysis and enforce a quality gate when enabled.
5. Run Checkmarx SAST when enabled; scanner failure blocks deployment.
6. Publish an immutable artifact to the configured artifact store.
7. Deploy to the selected environment with CodeDeploy and wait for terminal status.
8. Run post-deployment health checks and report the deployment result.

The Jenkinsfile uses Jenkins-managed SCM, Checkmarx, and AWS credential bindings; no credential value, account ID, or internal repository is embedded. Configure the AWS binding to use short-lived role credentials where the Jenkins installation supports it. Production requires approval and should use a separate role from lower environments.

## Integration contract

Configure Jenkins tools and credentials outside source control: SCM credential ID, AWS role, SonarQube installation, Checkmarx token, artifact bucket, CodeDeploy application/deployment group, and per-environment health-check URL. Keep secret values in the Jenkins credential store or an approved secret backend. The example references `example.com` as a placeholder domain.

The sample can be adapted to Maven, Gradle, Node, or container builds by replacing the build stage while retaining the promotion, scan, and deployment gates.
