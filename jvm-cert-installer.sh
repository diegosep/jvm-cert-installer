#!/bin/bash

HOST=
PORT=443 # Default port
KEYSTORE_FILE=cacerts # Default keystore file
KEYSTORE_PASS=changeit # Default keystore pass
JAVA_CACERTS_LOCATION=${JAVA_HOME}'lib/security' # Default cacert location

POSITIONAL=()
while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -h|--host)
    HOST="$2"
    shift
    shift
    ;;
    -p|--port)
    PORT="$2"
    shift
    shift
    ;;
    -f|--keystorefile)
    KEYSTORE_FILE="$2"
    shift
    shift
    ;;
    -a|--keystorepass)
    KEYSTORE_PASS="$2"
    shift
    shift
    ;;
    -l|--cacertlocation)
    JAVA_CACERTS_LOCATION="$2"
    shift # past argument
    shift # past value
    ;;
    *)    # unknown option
    POSITIONAL+=("$1") # save it in an array for later
    shift # past argument
    ;;
esac
done 

TEMP_CERTIFICATE=${HOST}.cert


# Checking variables
if [ -z "$JAVA_HOME" ]
then
    echo "\$JAVA_HOME is empty"
    exit 1
fi

if [ -z "$HOST" ]
then
    echo "\$HOST is empty, include option -h or --host"
    exit 1
fi

rm ${TEMP_CERTIFICATE} || true

cert_path=${JAVA_CACERTS_LOCATION}'/'${KEYSTORE_FILE}

# get the ssl file
openssl s_client -connect ${HOST}:${PORT} </dev/null \
| sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > ${TEMP_CERTIFICATE}

keytool -import -noprompt -trustcacerts \
        -alias ${HOST} -file ${TEMP_CERTIFICATE} \
        -keystore ${cert_path} -storepass ${KEYSTORE_PASS}

echo "... Checking certificate"
keytool -list -v -keystore ${cert_path} --storepass ${KEYSTORE_PASS} -alias ${HOST} 