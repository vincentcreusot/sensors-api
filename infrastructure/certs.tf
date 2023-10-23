#resource "tls_private_key" "ca" {
#  algorithm = "RSA"
#  rsa_bits  = 2048
#}
#
#resource "tls_self_signed_cert" "ca" {
#  private_key_pem = tls_private_key.ca.private_key_pem
#
#  validity_period_hours = 240
#
#  allowed_uses = [
#    "cert_signing",
#  ]
#
#  is_ca_certificate = true
#
#  subject {
#    organization = "iotsensors"
#  }
#}
#
#resource "tls_private_key" "signed_1" {
#  algorithm = "RSA"
#  rsa_bits  = 2048
#}
#
#resource "tls_cert_request" "signed_1" {
#  private_key_pem = tls_private_key.signed_1.private_key_pem
#
#  subject {
#    organization = "CA test"
#  }
#}
#
#resource "aws_iot_certificate" "iot_certificate" {
#  active = true
#  csr = tls_cert_request.signed_1
#}
data "local_file" "cert_input" {
  filename = var.iot_thing_cert
}

resource "aws_iot_certificate" "iot_certificate" {
  active = true
  certificate_pem = data.local_file.cert_input.content
}