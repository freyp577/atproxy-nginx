#!/bin/bash -e

function updateconf {
  j2 /templates/$1.j2 > $2/$1 
}

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
exec "$@"

