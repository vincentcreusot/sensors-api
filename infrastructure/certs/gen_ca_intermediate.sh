openssl genrsa -aes256 -out ca_intermediate.key 4096

openssl req -config ca_intermediate.cnf \
            -new -sha256 \
            -key ca_intermediate.key \
            -out ca_intermediate.csr

openssl ca -config ca_root.cnf \
           -extensions v3_intermediate_ca \
           -days 3653 -notext -md sha256 \
           -in ca_intermediate.csr \
           -out ca_intermediate.crt