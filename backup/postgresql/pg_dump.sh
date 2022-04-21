#!/bin/bash
function error() {
  echo -e "[ERR] : \e[91m⛔ $1 \e[39m"
  exit 1
}

env=("PGHOST" "PGUSER" "PGPASSWORD" "PGPORT" "PGDB")

# Check env
for t in ${env[@]}; do
  if [ -z $t ]; then
    error "Please set $t in your env file"
  fi
done

for db in $(echo $PGDB | tr ";" "\n"); do
  mkdir -p /data/$db/
  /usr/bin/pg_dump -Fc $db | gzip > /data/$db/$(date +%d-%m-%y).gz
done
