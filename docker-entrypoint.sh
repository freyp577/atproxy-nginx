#!/bin/bash -e

function updateconf {
  j2 /templates/$1.j2 > $2/$1 
}

updateconf production.conf /etc/nginx/conf.d/
updateconf staging.conf /etc/nginx/conf.d/

exec "$@"

#sleep infinity

