# Generate CA cert
echo "------ Generating CA cert ------"
echo "-- Specify password for CA key"
openssl genpkey -algorithm ED25519 > ed-ca.key
openssl genrsa -aes256 -out ca/ca.key 4096
openssl req -new -subj "/C=CA/O=lb/CN=ca.lb.com" -x509 -sha256 -days 20 -key ca/ca.key -out ca/ca.crt 