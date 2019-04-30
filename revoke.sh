echo "Revoke client2"
openssl ca -revoke client-certs/client2-crt.pem -keyfile ca/ca-key.pem -config cnfs/ca.cnf -cert ca/ca-crt.pem -passin 'pass:password'

echo "Updating the CRL"
openssl ca -keyfile ca/ca-key.pem -cert ca/ca-crt.pem -config cnfs/ca.cnf -gencrl -out ca/ca-crl.pem -passin 'pass:password'
