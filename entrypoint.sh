# aws sts assume-role --role-arn ${AWS_ROLE_ARN} --role-session-name dp-action-aiven-ssl

eval $(aws sts assume-role --role-arn arn:aws:iam::123456789123:role/myAwesomeRole --role-session-name test | jq -r '.Credentials | "export AWS_ACCESS_KEY_ID=\(.AccessKeyId)\nexport AWS_SECRET_ACCESS_KEY=\(.SecretAccessKey)\nexport AWS_SESSION_TOKEN=\(.SessionToken)\n"')

key_response=$(aws ssm get-parameter --name ${SERVICE_KEY_PATH} --with-decryption --query "Parameter.Value")

cert_response=$(aws ssm get-parameter --name ${SERVICE_CERT_PATH} --with-decryption --query "Parameter.Value")

ca_response=$(aws ssm get-parameter --name ${CA_PATH} --with-decryption --query "Parameter.Value")

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