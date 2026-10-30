# CloudFront Module Design

The source Terraform module supported S3, ALB, or combined origins; ordered cache behaviors; custom domains; geo restrictions; WAF association; and viewer/origin request policies. The original S3 origin access identity is replaced by Origin Access Control (OAC), which is the preferred modern direction for private S3 origins.

The implementation in `main.tf` creates the distribution, an optional private S3 origin with Origin Access Control, an optional ALB origin, ordered cache behaviors, aliases, geographic restrictions, and optional WAF association. The default cache behavior targets the configured origin; additional path behaviors are explicit inputs. CloudFront distributions are global, and viewer TLS certificate ARNs must be in `us-east-1`.

The S3 bucket policy must grant CloudFront service access through the distribution's OAC; this module does not silently make a bucket public. The module also does not choose cache policies for an application: select request/cache policies that preserve required query strings and headers without forwarding credentials or cookies unnecessarily. Use `example.com` for local hostnames and validate in a disposable account before applying.
