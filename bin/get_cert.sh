#!/bin/bash


# openssl s_client -connect subdomain.host.com:443 -servername subdomain.host.com < /dev/null | openssl x509 -outform DER > certicatename.cer

openssl s_client -connect "${1}":443 -servername "${1}" < /dev/null | openssl x509 -outform DER > "${2}"