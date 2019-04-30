echo "Cleanup:"
echo "  Clean up CA"
rm -rf ca

echo "  Clean up server keys"
rm -rf server-keys

echo "  Cleaning up client certificates"
rm -rf client-certs

echo "  Cleaning up revocation list db"
rm -rf revoke

echo "Setup directories"
mkdir ca
mkdir server-keys
mkdir client-certs
mkdir revoke

echo
echo "1. Set up the CA:"
echo "  1. Generate new CA"
openssl req -new -x509 -days 9999 -config cnfs/ca.cnf -keyout ca/ca-key.pem -out ca/ca-crt.pem

echo
echo "2. Set up the server side:"
echo "  1. Generate new server key"
openssl genrsa -out server-keys/server-key.pem 4096

echo "  2. Generate server key signing request"
openssl req -new -config cnfs/server.cnf -key server-keys/server-key.pem -out server-keys/server-csr.pem
echo "  3. Sign the server key"
openssl x509 -req -extfile cnfs/server.cnf -days 999 -passin "pass:password" -in server-keys/server-csr.pem -CA ca/ca-crt.pem -CAkey ca/ca-key.pem -CAcreateserial -out server-keys/server-crt.pem

echo
echo "3. Set up the clients side:"
echo "  1. Client1:"
echo "     1. Generate private key"
openssl genrsa -out client-certs/client1-key.pem 4096

echo "     2. Generate client key signing request"
openssl req -new -config cnfs/client1.cnf -key client-certs/client1-key.pem -out client-certs/client1-csr.pem

echo "     3. Sign the client key"
openssl x509 -req -extfile cnfs/client1.cnf -days 999 -passin "pass:password" -in client-certs/client1-csr.pem -CA ca/ca-crt.pem -CAkey ca/ca-key.pem -CAcreateserial -out client-certs/client1-crt.pem

echo "     4. Test signed key"
openssl verify -CAfile ca/ca-crt.pem client-certs/client1-crt.pem

echo "  2. Client2: "
echo "     1. Generate private key"
openssl genrsa -out client-certs/client2-key.pem 4096

echo "     2. Generate client key signing request"
openssl req -new -config cnfs/client2.cnf -key client-certs/client2-key.pem -out client-certs/client2-csr.pem

echo "     3. Sign the client key"
openssl x509 -req -extfile cnfs/client2.cnf -days 999 -passin "pass:password" -in client-certs/client2-csr.pem -CA ca/ca-crt.pem -CAkey ca/ca-key.pem -CAcreateserial -out client-certs/client2-crt.pem

echo "     4. Test signed key"
openssl verify -CAfile ca/ca-crt.pem client-certs/client2-crt.pem

echo
echo "4. Set up revokation list database"
echo "   1. Initialize revocation DB"
touch revoke/ca-database.txt
openssl ca -keyfile ca/ca-key.pem -cert ca/ca-crt.pem -config cnfs/ca.cnf -gencrl -out ca/ca-crl.pem -passin 'pass:password'
