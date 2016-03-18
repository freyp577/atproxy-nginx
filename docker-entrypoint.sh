#!/bin/bash -e

updateconf /templates/production.conf.j2 >/etc/nginx/conf.d/production.conf
updateconf /templates/staging.conf.j2 >/etc/nginx/conf.d/staging.conf

exec "$@"

#sleep infinity

