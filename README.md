# docker-centos-mirror

docker-compose.yml to create centos-mirror proxy with [docker-squid](https://github.com/kumattau/docker-squid).

## Purpose

On CentOS, repositories that have reached EOL are moved to vault, so *.repo files must be modified in order to access them.

```
bash-4.4# yum update
CentOS Linux 8 - AppStream    40  B/s |  38  B     00:00    
Error: Failed to download metadata for repo 'appstream': Cannot prepare internal mirrorlist: No URLs in mirrorlist
```

By using this proxy, you can access the repositories on CentOS that have reached EOL without modifying the *.repo files.

## Usage

Start proxy server.

```
$ docker compose up

[+] Running 2/0
 ✔ Container docker-centos-mirror-httpd-1  Created
 ✔ Container docker-centos-mirror-squid-1  Created
```

Access repositories via the proxy (`172.17.0.1` needs to be replaced with your ip address).

```
# export http_proxy=http://172.17.0.1:3128
# export https_proxy=http://172.17.0.1:3128
# echo sslverify=0 >> /etc/yum.conf
# yum update
CentOS Linux 8 - AppStream    5.2 MB/s | 8.4 MB     00:01    
CentOS Linux 8 - BaseOS       7.0 MB/s | 4.6 MB     00:00    
CentOS Linux 8 - Extras       205 kB/s |  10 kB     00:00    
Dependencies resolved.
Nothing to do.
Complete!
```

As default, ssl-bump uses the following self-signed certificate files generated at build time:

* `/usr/local/squid/var/lib/squid/ssl-bump.key`
* `/usr/local/squid/var/lib/squid/ssl-bump.crt`
* `/usr/local/squid/var/lib/squid/ssl-bump.pem` (this is concatenation of `ssl-bump.key` and `ssl-bump.crt`)

You can get the self-signed certificate as follows:

```
$ docker compose exec -ti squid cat /usr/local/squid/var/lib/squid/ssl-bump.crt
```

You can change repository by `REPOURL` environment variable.

## Notice

* This is not ready for production use.
* This is under MIT license, but the docker image created docker-compose.yml contains [docker-squid](https://github.com/kumattau/docker-squid).
