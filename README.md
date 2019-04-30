A little example of how to get mutual tls going in node, following this blog post https://engineering.circle.com/https-authorized-certs-with-node-js-315e548354a2.

# Usage
1. Clone and run `npm install` to get any dependencies (using only `fs` and `tls`)
2. Run `setup.sh`. This will go through all the steps:
   1. Generate a new CA
   2. Generate the server's key and sign them with the CA
   3. Generate the client's keys and sign them with the CA (generates 2 clients)
   4. Establish a revocation list database
3. Run `node server.js` to start the server
4. Run `node client.js 1` to start client 1 or `2` for client 2.
5. To test revocation, run `revoke.sh`
5. Restart both server and client for the change to take effect
