# terraform-module-cloudfront
Este módulo cria uma distribuição CloudFront configurável, permitindo usar múltiplos buckets S3 como origem. Ideal para cenários onde diferentes aplicações ou ambientes compartilham uma CDN comum.

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudfront_distribution.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution) | resource |
| [aws_cloudfront_origin_access_control.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_origin_access_control) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_acm_certificate_arn"></a> [acm\_certificate\_arn](#input\_acm\_certificate\_arn) | ARN do certificado ACM para HTTPS. Se nulo, usa o certificado padrão do CloudFront. | `string` | `null` | no |
| <a name="input_aliases"></a> [aliases](#input\_aliases) | Lista de domínios alternativos (CNAMEs). | `list(string)` | `[]` | no |
| <a name="input_comment"></a> [comment](#input\_comment) | Comentário descritivo da distribuição CloudFront. | `string` | n/a | yes |
| <a name="input_default_cache_behavior"></a> [default\_cache\_behavior](#input\_default\_cache\_behavior) | Configuração de comportamento padrão de cache. | <pre>object({<br>    target_origin_id       = string<br>    viewer_protocol_policy = string<br>    allowed_methods        = list(string)<br>    cached_methods         = list(string)<br>    compress               = bool<br>    default_ttl            = optional(number)<br>    max_ttl                = optional(number)<br>    min_ttl                = optional(number)<br>    query_string           = optional(bool)<br>    cookies_forward        = optional(string)<br>  })</pre> | n/a | yes |
| <a name="input_default_root_object"></a> [default\_root\_object](#input\_default\_root\_object) | Objeto raiz padrão (ex: index.html). | `string` | `null` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Define se a distribuição CloudFront está habilitada. | `bool` | `true` | no |
| <a name="input_logging_config"></a> [logging\_config](#input\_logging\_config) | Configuração opcional de logs. | <pre>object({<br>    bucket          = string<br>    include_cookies = optional(bool)<br>    prefix          = optional(string)<br>  })</pre> | `null` | no |
| <a name="input_ordered_cache_behaviors"></a> [ordered\_cache\_behaviors](#input\_ordered\_cache\_behaviors) | Lista opcional de cache behaviors adicionais. | <pre>list(object({<br>    path_pattern           = string<br>    target_origin_id       = string<br>    viewer_protocol_policy = string<br>    allowed_methods        = list(string)<br>    cached_methods         = list(string)<br>    compress               = bool<br>    query_string           = optional(bool)<br>    cookies_forward        = optional(string)<br>  }))</pre> | `[]` | no |
| <a name="input_origins"></a> [origins](#input\_origins) | Lista de buckets S3 a serem usados como origins. | <pre>list(object({<br>    id                     = string<br>    domain_name             = string<br>    path                    = optional(string)<br>    origin_access_control   = optional(bool, false)<br>    origin_access_identity  = optional(string)<br>  }))</pre> | n/a | yes |
| <a name="input_price_class"></a> [price\_class](#input\_price\_class) | Classe de preço (PriceClass\_100, PriceClass\_200, All). | `string` | `"PriceClass_100"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cloudfront_arn"></a> [cloudfront\_arn](#output\_cloudfront\_arn) | ARN da distribuição CloudFront. |
| <a name="output_cloudfront_distribution_id"></a> [cloudfront\_distribution\_id](#output\_cloudfront\_distribution\_id) | ID da distribuição CloudFront. |
| <a name="output_cloudfront_domain_name"></a> [cloudfront\_domain\_name](#output\_cloudfront\_domain\_name) | Domínio gerado pelo CloudFront (ex: d111111abcdef8.cloudfront.net) |
| <a name="output_cloudfront_hosted_zone_id"></a> [cloudfront\_hosted\_zone\_id](#output\_cloudfront\_hosted\_zone\_id) | O Hosted Zone ID do CloudFront (necessário para criar um registro ALIAS no Route 53). |
<!-- END_TF_DOCS -->