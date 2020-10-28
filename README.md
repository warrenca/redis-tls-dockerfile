# Docker image for Redis

[![Build Status](https://travis-ci.com/madflojo/redis-tls-dockerfile.svg?branch=master)](https://travis-ci.com/madflojo/redis-tls-dockerfile) 

Redis + stunnel Dockerfile for TLS on top of Redis.

## Features
- Stunnel for TLS
- Redis password support

## Generating a key and cert
```console
$ openssl req -x509 -newkey rsa:4096 -sha256 -days 3650 -nodes \
  -keyout ./certs/cert.key -out ./certs/cert.crt -extensions san -config \
  <(echo "[req]"; 
    echo distinguished_name=req; 
    echo "[san]"; 
    echo subjectAltName=DNS:localhost,DNS:localhost,IP:127.0.0.1
    ) \
  -subj "/CN=localhost"
$ openssl x509 -in ./certs/cert.crt -out ./certs/cert.pem -outform PEM
$ mv ./certs/cert.key ./certs/cert.pem
```

## Starting Container 

### without password

```console
$ docker run -d -p 6379:6379 -v /path/to/certs:/certs --name pam-redis mediabankpam/pam-redis-v5-with-auth-and-ssl
```

### with password

```console
$ docker run -d -p 6379:6379 -v certs:/certs --env REDIS_PASS="<<password here>>" --name pam-redis mediabankpam/pam-redis-v5-with-auth-and-ssl
```

### For persistence, mount /data

```console
$ docker run --restart=always -d -p 6379:6379 -v /path/to/certs:/certs -v /hostpath/to/redisdatabackup:/data --env REDIS_PASS="<<password here>>" --name pam-redis mediabankpam/pam-redis-v5-with-auth-and-ssl
```


The `./certs` should be a directory on the host that contains the appropriate `cert.pem` and `key.pem` files for `stunnel` to provide TLS encryption.
