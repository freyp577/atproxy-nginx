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

RUN mkdir -p /etc/nginx/ssl
# leave empty, used mount at runtime from docker host
#VOLUME /etc/nginx/ssl

RUN cd /etc/nginx/conf.d && rm *.conf 

COPY *.j2 /templates/
COPY baustelle /usr/share/nginx/html/baustelle
COPY docker-entrypoint.sh /
RUN chmod o+x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]

