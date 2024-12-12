# args checks
if [ -z "$1" ]
then
  echo "Please supply a subdomain to create a certificate for";
  echo "e.g. mysite.localhost"
  exit;
fi
if [ -z "$2" ]
then
  echo "Please supply an IP  to create a certificate for";
  exit;
fi

# params
DOMAIN=$1
IP=$2
SUBJECT="/C=CA/ST=None/L=NB/O=None/CN=$DOMAIN"
NUM_OF_DAYS=365

# root ca generate
openssl genrsa -out rootCA.key 2048
openssl req -x509 -new -nodes -key rootCA.key -sha256 -days 1024 -out rootCA.pem

# create request
openssl req -new -newkey rsa:2048 -sha256 -nodes -keyout $DOMAIN.key -subj "$SUBJECT" -out $DOMAIN.csr

# sign request and make domain cert
cat cert.ext | sed s/%%DOMAIN%%/$DOMAIN/g | sed s/%%IP%%/$IP/g > /tmp/__cert.ext
openssl x509 -req -in $DOMAIN.csr -CA rootCA.pem -CAkey rootCA.key -CAcreateserial -out $DOMAIN.crt -days $NUM_OF_DAYS -sha256 -extfile /tmp/__cert.ext
rm /tmp/__cert.ext

# base64 encode
cat microk8s.nedorezov.ru.crt | base64 -w 0 > $DOMAIN.crt.b64
cat microk8s.nedorezov.ru.key | base64 -w 0 > $DOMAIN.key.b64