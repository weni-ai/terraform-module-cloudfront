# Adicionando uma saída para o ARN da distribuição
output "cloudfront_arn" {
  value       = aws_cloudfront_distribution.this.arn
  description = "ARN da distribuição CloudFront."
}

# Adicionando uma saída para a distribuição CloudFront
output "cloudfront_distribution_id" {
  value       = aws_cloudfront_distribution.this.id
  description = "ID da distribuição CloudFront."
}

# Saída para o domínio do CloudFront
output "cloudfront_domain_name" {
  value       = aws_cloudfront_distribution.this.domain_name
  description = "Domínio gerado pelo CloudFront (ex: d111111abcdef8.cloudfront.net)"
}

# Saída para da Hosted Zone padrão do CloudFront
output "cloudfront_hosted_zone_id" {
  value       = aws_cloudfront_distribution.this.hosted_zone_id
  description = "O Hosted Zone ID do CloudFront (necessário para criar um registro ALIAS no Route 53)."
}