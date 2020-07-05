# jvm-cert-installer
Bash script for installing certificates

**JAVA_HOME** is required

## Run it (with sudo)
```
sudo JAVA_HOME=$JAVA_HOME ./jvm-cert-installer.sh --host google.com
```

## Command options
| Command | Short Command | Description | Default value | 
| -------------  | ------------- | ------------- | ------------- |
| --host  | -h   | Host, I.e.: _google.com_ |  | **Required** |
| --port         | -p | Host port | **443** |
| --keystorefile | -f | Keystore file name | **cacerts** | 
| --keystorepass | -a | Keystore file password | **changeit** |
| --cacertlocation | -l | cacerts location file | **$JAVA_HOME/lib/security** |
