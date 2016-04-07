#!/bin/bash -e

function updateconf {
  j2 /templates/$1.j2 > $2/$1 
}

# use environment variable tz to set timezone
# sudo timedatectl set-timezone ${tz:=Europe/Berlin}
# causes Failed to create bus connection: No such file or directory
# https://github.com/docker/docker/issues/12084 
#
# see https://docs.docker.com/engine/userguide/eng-image/dockerfile_best-practices/
# should not use sudo - unpredictable TTY and signal-forwarding benavior
# so moved the following to Dockerfile itself, before switching to user atproxy
#echo ${tz:=Europe/Berlin} >/etc/timezone
#sudo dpkg-reconfigure -f noninteractive tzdata

# workaround for locale: Cannot set LC_CTYPE to default locale: No such file or directory
locale-gen de_DE.UTF-8

#echo update nginx conf for $color
updateconf production.conf /etc/nginx/conf.d/
updateconf staging.conf /etc/nginx/conf.d/

mkdir -p /usr/share/nginx/html/status
#echo update bluegreen.txt for $color 
echo $color >/usr/share/nginx/html/status/bluegreen.txt 

echo update bluegreen.txt for $color `date '+%Y-%m-%dT%H:%M:%S'`
cat << EOF > /usr/share/nginx/html/status/bluegreen.json
{"active": "$color", "started": "`date '+%Y-%m-%dT%H:%M:%S'`"} 
EOF

#echo run "$@"
#echo 
exec "$@"

