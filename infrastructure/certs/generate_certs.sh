#!/bin/sh
# Generate CA cert
echo "------ Generating CA cert ------"
echo "-- Specify password for CA key"
openssl genrsa -aes256 -out ca.key 2048
openssl req -new -subj "/C=CA/O=iot/CN=ca.vincentcreusot.com" -x509 -sha256 -days 365 -extensions v3_ca -nodes -key ca.key -out ca.crt

# Generate CSR for server
echo "------ Generating Thing cert ------"
echo "-- Specify password for Thing 1 key"
openssl genrsa -aes256 -out thing1.key 2048
openssl rsa -in thing1.key -out thing1.key.pem
openssl req -new -nodes -subj "/C=CA/O=iot/CN=picow-bme680.vincentcreusot.com" -key thing1.key -sha256 -out thing1.csr
# Validate CSR
openssl x509 -req -days 365 -sha256 -in thing1.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out thing1.crt
