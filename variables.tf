# Variáveis do módulo CloudFront
variable "enabled" {
  description = "Define se a distribuição CloudFront está habilitada."
  type        = bool
  default     = true
}

variable "comment" {
  description = "Comentário descritivo da distribuição CloudFront."
  type        = string
}

variable "price_class" {
  description = "Classe de preço (PriceClass_100, PriceClass_200, All)."
  type        = string
  default     = "PriceClass_100"
}

variable "default_root_object" {
  description = "Objeto raiz padrão (ex: index.html)."
  type        = string
  default     = null
}

variable "acm_certificate_arn" {
  description = "ARN do certificado ACM para HTTPS. Se nulo, usa o certificado padrão do CloudFront."
  type        = string
  default     = null
}

variable "aliases" {
  description = "Lista de domínios alternativos (CNAMEs)."
  type        = list(string)
  default     = []
}

variable "origins" {
  description = "Lista de buckets S3 a serem usados como origins."
  type = list(object({
    id                     = string
    domain_name             = string
    path                    = optional(string)
    origin_access_control   = optional(bool, false)
    origin_access_identity  = optional(string)
  }))
}

variable "default_cache_behavior" {
  description = "Configuração de comportamento padrão de cache."
  type = object({
    target_origin_id       = string
    viewer_protocol_policy = string
    allowed_methods        = list(string)
    cached_methods         = list(string)
    compress               = bool
    default_ttl            = optional(number)
    max_ttl                = optional(number)
    min_ttl                = optional(number)
    query_string           = optional(bool)
    cookies_forward        = optional(string)
  })
}

variable "ordered_cache_behaviors" {
  description = "Lista opcional de cache behaviors adicionais."
  type = list(object({
    path_pattern           = string
    target_origin_id       = string
    viewer_protocol_policy = string
    allowed_methods        = list(string)
    cached_methods         = list(string)
    compress               = bool
    query_string           = optional(bool)
    cookies_forward        = optional(string)
  }))
  default = []
}

variable "logging_config" {
  description = "Configuração opcional de logs."
  type = object({
    bucket          = string
    include_cookies = optional(bool)
    prefix          = optional(string)
  })
  default = null
}
