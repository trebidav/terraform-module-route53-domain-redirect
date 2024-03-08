# Route53 Domain Redirect

![Diagram](domain-redirect-diagram.png)

This Terraform module works together with AWS Route53, S3, ACM and CloudFront to create permanent redirect of a domain to a target URL.

Both www and apex A records are created and pointed to a CloudFront distribution. The distribution accepts HTTP and HTTPS connections (free autorenewing ACM certificate is used for HTTPS). The origin for CloudFront distribution is a S3 hosted website with redirect-all rule. This solution is cheap and maintenance free.

**Requirements:** DNS Zone in Route53

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloudfront_forward_query_string"></a> [cloudfront\_forward\_query\_string](#input\_cloudfront\_forward\_query\_string) | Toggle forwarding of query strings for CloudFront | `bool` | `false` | no |
| <a name="input_cloudfront_wait_for_deployment"></a> [cloudfront\_wait\_for\_deployment](#input\_cloudfront\_wait\_for\_deployment) | Toggle wait for deployment for CloudFront | `bool` | `false` | no |
| <a name="input_subdomain"></a> [subdomain](#input\_subdomain) | Subdomain for the CloudFront (has to end with a dot if not empty!) | `string` | `""` | no |
| <a name="input_target_url"></a> [target\_url](#input\_target\_url) | URL to redirect to | `string` | n/a | yes |
| <a name="input_zone"></a> [zone](#input\_zone) | Route53 zone name | `string` | n/a | yes |
