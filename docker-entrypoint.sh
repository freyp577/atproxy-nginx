#!/bin/bash -e

function updateconf {
  j2 /templates/$1.j2 > $2/$1 
}

updateconf production.conf /etc/nginx/conf.d/
updateconf staging.conf /etc/nginx/conf.d/

echo $color >/usr/share/nginx/html/bluegreen.txt 
cat << EOF > /usr/share/nginx/html/bluegreen.json
{"active": "$color", "started": "`date '+%Y-%m-%dT%H:%M:%S'`"} 
EOF

exec "$@"

#sleep 

