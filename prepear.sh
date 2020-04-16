# Edit settings to taste
# This is the IP of your host machine, things might need it
hostip=CHANGEME
# Edit these if you don't love hard-coded creds
default_uname=default_uname
default_pass=default_pass
# Change if you don't like my password crypt
# Note that if you change creds later you'll also need to calculate the new crypt password
default_crypt_pass=$(echo -n $default_pass | mkpasswd -s -5)

# Probably best not to mess around past here

# Configure docker environment variables.
echo HOST_IP=$hostip > .env
echo DEFAULT_UNAME=$default_uname >> .env
echo DEFAULT_PASS=$default_pass >> .env
echo DEFAULT_CRYPT_PASS=$default_crypt_pass >> .env

# Create directories and sort out permissions
mkdir r w x secrets
chgrp -R docker r
chgrp -R docker w
chgrp -R docker x
chgrp -R docker secrets

# Prepare keys
cd secrets
# Firt sort out TLS keys and that
openssl genrsa -out key.pem 2048
chmod 644 key.pem
openssl req -new -x509 -out cert.pem -key key.pem -days 3650 -subj /CN=$hostip -sha256
openssl req -new -x509 -out sha1cert.pem -key key.pem -days 3650 -subj /CN=$hostip -sha1
cat key.pem cert.pem > certkey.pem
# TODO make sure permissions are all good
#chmod 644 certkey.pem
cat key.pem sha1cert.pem > sha1certkey.pem
#chmod 644 sha1certkey.pem
openssl dhparam -out dhparams.pem 2048
# Now for SSH
ssh-keygen -f ./ssh_rsa -t rsa -b 2048 -N ''
ssh-keygen -f ./ssh_ed25519 -t ed25519 -N ''
cd ..
