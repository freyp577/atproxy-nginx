#!/bin/bash -e

function updateconf {
  j2 /templates/$1.j2 > $2/$1 
}

# use environment variable tz to set timezone
# sudo timedatectl set-timezone ${tz:=Europe/Berlin}
# causes Failed to create bus connection: No such file or directory
# https://github.com/docker/docker/issues/12084 
echo ${tz:=Europe/Berlin} >/etc/timezone
dpkg-reconfigure -f noninteractive tzdata

echo update nginx conf for $color
updateconf production.conf /etc/nginx/conf.d/
updateconf staging.conf /etc/nginx/conf.d/

echo update bluegreen.txt for $color 
echo $color >/usr/share/nginx/html/bluegreen.txt 

echo update bluegreen.txt for $color `date '+%Y-%m-%dT%H:%M:%S'`
cat << EOF > /usr/share/nginx/html/bluegreen.json
{"active": "$color", "started": "`date '+%Y-%m-%dT%H:%M:%S'`"} 
EOF

echo run "$@"
echo 
exec "$@"

