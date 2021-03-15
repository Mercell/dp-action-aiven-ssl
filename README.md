# dp-action-aiven-ssl

Example: 

on: [push]

jobs:
  my_job:
    runs-on: ubuntu-latest
    name: A job to generate ssh certificates
    steps:
    - uses: actions/checkout@v2
    - id: foo
      uses: actions/dp-action-aiven-ssl@v1
      with:
        service_key_path: "/serivce/key"
        service_cert_path: "/service/cert"
        service_ca_path: "/service/ca"
        keystore_password_path: "/keystore/password"
        truststore_password_path: "/truststore/password"
        aws_acces_key_id: "SOME AWS ACCESS KEY ID"
        aws_secret_access_key: "SOME SECRET ACCESS KEY"
        aws_default_region: "eu-central-1"