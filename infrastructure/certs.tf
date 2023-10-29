resource "tls_private_key" "signed_1" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "tls_cert_request" "signed_1" {
  private_key_pem = tls_private_key.signed_1.private_key_pem

  subject {
    organization = "iot.rpi.com"
    common_name = "thing1.iot.rpi.com"
  }
}

data "tls_certificate" "aws_root_ca" {
  url = "https://www.amazontrust.com/repository/AmazonRootCA1.pem"
}

resource "aws_iot_certificate" "iot_certificate" {
  active = true
  csr = tls_cert_request.signed_1.cert_request_pem
}

output "thing_cert_pem" {
  value = aws_iot_certificate.iot_certificate.certificate_pem
  sensitive = true
}

output "thing_key_pem" {
  value = tls_private_key.signed_1.private_key_pem
  sensitive = true
}

output "aws_root_ca_pem" {
  sensitive = true
  value = data.tls_certificate.aws_root_ca.content
}