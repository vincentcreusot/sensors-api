variable "iot_custom_ca" {
  description = "File containing the CA to register"
  type        = string
  default     = "certs/ca.crt"
}

variable "iot_thing_cert" {
  description = "File containing the cert of the thing to register"
  type        = string
  default     = "certs/thing1.crt"
}

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}