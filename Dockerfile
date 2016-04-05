# atproxcyconf Dockerfile
# ideas / adapted from 
# http://blog.tryolabs.com/2015/03/26/configurable-docker-containers-for-multiple-environments/
#
#FROM nginx:stable  
#ATTN TCP reverse proxy / stream module requires 1.9.1, stable is 1.8.x

FROM nginx:latest

RUN apt-get update --yes && \
    apt-get install --yes python-dev python-setuptools 
RUN easy_install j2cli

EXPOSE 80 443
# note: port 80 for internal and administrative use

RUN useradd -m atproxy && \
  echo "atproxy:${atproxypwd:=atproxy}" | chpasswd 
# note: use strong service account password for user atproxy
# BUT do not hardcode it in Dockerfile

RUN mkdir -p /etc/nginx/ssl
# leave empty, used mount at runtime from docker host
#VOLUME /etc/nginx/ssl

RUN cd /etc/nginx/conf.d && rm *.conf 

RUN mkdir -p /templates && \
    chown atproxy:atproxy /templates && \
    chown -R atproxy:root /etc/nginx && \
    mkdir -p /usr/share/nginx/html/status && \
    chown atproxy:root /usr/share/nginx/html/status && \
    mkdir -p /var/cache/nginx && chown atproxy:root /var/cache/nginx && \
    mkdir -p /var/log/nginx && chown atproxy:root /var/log/nginx && \ 
    chown atproxy:root /var/run 

COPY docker-entrypoint.sh /
RUN chmod o+x /docker-entrypoint.sh && \
    chown atproxy:root /docker-entrypoint.sh 

# set timezone
#sudo timedatectl set-timezone ${tz:=Europe/Berlin}
# causes Failed to create bus connection: No such file or directory
# https://github.com/docker/docker/issues/12084
#
RUN echo ${TZ:=Europe/Berlin} >/etc/timezone && \
    dpkg-reconfigure -f noninteractive tzdata

# switch user as commanded by Docker Security Benchmark
USER atproxy

COPY *.j2 /templates/
COPY baustelle /usr/share/nginx/html/baustelle

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]

