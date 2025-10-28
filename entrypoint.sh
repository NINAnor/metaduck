#!/bin/bash

set -o errexit
set -o pipefail

# Connecting to LDAPS may require custom CA certificates installed
if [[ -z "${LDAP_CA_FILE_PATH}" ]]
then
  echo "CA cert not installed"
else
  update-ca-certificates
  /opt/java/openjdk/bin/keytool -noprompt -import -trustcacerts -alias ldaps-cert -file $LDAP_CA_FILE_PATH -keystore /etc/ssl/certs/java/cacerts -keypass changeit -storepass changeit
fi

exec "$@"
