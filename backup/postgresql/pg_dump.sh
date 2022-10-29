#!/bin/bash
function error() {
  echo -e "[ERR] : \e[91m⛔ $1 \e[39m"
  exit 1
}

# Env var to check
env=("PGHOST" "PGUSER" "PGPASSWORD" "PGPORT" "PGDB")

# Check env
for t in ${env[@]}; do
  if [ -z $t ]; then
    error "Please set $t in your env file"
  fi
done

if [ "$PGDB" == "***" ]; then
  # Query all db and ignore template
  PGDB=$(psql -c "SELECT datname FROM pg_database WHERE datistemplate = false;" --csv | awk '(NR>1)')
fi

for db in $(echo $PGDB | tr ";" "\n"); do
    # Create dir (does nothing if exist)
    mkdir -p /data/$db/ 
    # Create backup and store it in archive 
    /usr/bin/pg_dump -Fc $db | gzip > /data/$db/$(date +%d-%m-%y).gz
    # Change permission
    chmod 770 /data/$db/
    chmod 770 /data/$db/$(date +%d-%m-%y).gz
done