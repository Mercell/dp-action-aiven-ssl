key_response=$(aws ssm get-parameter --name ${SERVICE_KEY_PATH} --query "Parameter.Value")

cert_response=$(aws ssm get-parameter --name ${SERVICE_CERT_PATH} --query "Parameter.Value")

ca_response=$(aws ssm get-parameter --name ${CA_PATH} --query "Parameter.Value")

keystore_password_response=$(aws ssm get-parameter --name ${KEYSTORE_PASSWORD_PATH} --with-decryption --query "Parameter.Value")

truststore_password_response=$(aws ssm get-parameter --name ${TRUSTSTORE_PASSWORD_PATH} --with-decryption --query "Parameter.Value")

echo -e "$key_response" | sed -e 's/^"//' -e 's/"$//' > service.key

echo -e "$cert_response" | sed -e 's/^"//' -e 's/"$//' > service.cert

echo -e "$ca_response" | sed -e 's/^"//' -e 's/"$//' > ca.pem

KEYSTORE_PASSWORD=$(sed -e 's/^"//' -e 's/"$//' <<< $keystore_password_response)

TRUSTSTORE_PASSWORD=$(sed -e 's/^"//' -e 's/"$//' <<< $truststore_password_response)

openssl pkcs12 -export -inkey service.key -in service.cert -out client.keystore.p12 -name service_key -passout pass:${KEYSTORE_PASSWORD}
keytool -import -file ca.pem -alias CA -keystore client.truststore.jks -storepass ${TRUSTSTORE_PASSWORD} -noprompt

rm service.key service.cert ca.pem

ls