# dp-action-aiven-ssl

This action generates keystore and truststore on the github action machine from ssm parameters, available for your dockerfile to pick up and copy them to it's image.

Example: 
```
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
        working_directory: ./directory-to-add-files-to
```
