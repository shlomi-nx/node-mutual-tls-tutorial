const tls = require('tls');
const fs = require('fs');

const options = { 
    key: fs.readFileSync('server-keys/server-key.pem'),  // server's private key
    cert: fs.readFileSync('server-keys/server-crt.pem'), // server's signed public key
    ca: fs.readFileSync('ca/ca-crt.pem'),  // the ca certificate - needs to be published
    crl: fs.readFileSync('ca/ca-crl.pem'), // the ca revocation list
    requestCert: true, 
    rejectUnauthorized: true
}; 

const server = tls.createServer(options, (socket) => {
  console.log('server connected', 
              socket.authorized ? 'authorized' : 'unauthorized');
  console.log(new Date()+' '+ 
              socket.getPeerCertificate().subject.CN); 
  socket.on('error', (error) => {
    console.log(error);
  });
  
  socket.write('welcome!\n');
  socket.setEncoding('utf8');
  socket.pipe(process.stdout);
  socket.pipe(socket);
});


server.listen(8000, () => {
    console.log('server bound');
});
