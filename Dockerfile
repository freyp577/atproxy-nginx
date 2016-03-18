# atproxcyconf Dockerfile
# ideas / adapted from 
# http://blog.tryolabs.com/2015/03/26/configurable-docker-containers-for-multiple-environments/
#
FROM nginx:stable
RUN apt-get update --yes && \
    apt-get install --yes python-dev python-setuptools
RUN easy_install j2cli

RUN mkdir -p /etc/nginx/ssl
# leave empty, used mount at runtime from docker host
#VOLUME /etc/nginx/ssl

#RM /etc/nginx/conf.d/default.conf

COPY production.conf.j2 /templates/
COPY staging.conf.j2 /templates/
COPY docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]

