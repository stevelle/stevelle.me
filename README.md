stevelle.me
===========
Contains the source used to generate the website found at https://stevelle.me


Server Deployment
-----------------
1 spin up the target host (manually)
1 set up DNS for the host, including ptr record
1 run `scripts/bootstrap-server.sh` on the remote host
1 answer all the questions along the way
1 scp the certificate file and private key to the target host (not in repo)
1 run `ansible-playbook -i hosts web.yml` 


