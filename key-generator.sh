INSTALLER="yum install"

#install openssl tool
sudo $INSTALLER -y openssl

KEYSTORE_PATH="/root"
cd $KEYSTORE_PATH

KEY_FILE_NAME="my_key_file"
PASSWORD="my_password"
COMMON_NAME="127.0.0.1"
KEYSTORE_NAME="my_keystore"
KEYSTORE_PASSWORD="changeit"

openssl genrsa -des3 -out $KEY_FILE_NAME.key -passout pass:$PASSWORD 1024
openssl req -new -key $KEY_FILE_NAME.key -subj '/CN=$COMMON_NAME' -passin pass:$PASSWORD -out $KEY_FILE_NAME.csr 
openssl x509 -req -days 365 -in $KEY_FILE_NAME.csr -signkey $KEY_FILE_NAME.key -passin pass:$PASSWORD -out $KEY_FILE_NAME.crt
openssl pkcs12 -inkey $KEY_FILE_NAME.key -in $KEY_FILE_NAME.crt -passin pass:$PASSWORD -passout pass:$PASSWORD -export -out $KEY_FILE_NAME.pkcs12
keytool -importkeystore -srckeystore $KEY_FILE_NAME.pkcs12 -srcstoretype PKCS12 -destkeystore keystore -deststorepass $PASSWORD -srcstorepass $PASSWORD
yes | keytool -keystore $KEYSTORE_NAME -importcert -alias a -file $KEY_FILE_NAME.crt -storepass $KEYSTORE_PASSWORD
