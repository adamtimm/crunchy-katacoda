#!/usr/bin/bash

#runs in foreground

echo 'please wait while we prep the environment (should take about 15 seconds)'
echo 'starting the database'
docker run -d -p 5432:5432 -e PG_USER=groot -e PG_PASSWORD=iam -e PG_DATABASE=firedata -e PG_ROOT_PASSWORD=root --name=pgsql crunchydata/crunchy-postgres-appdev

until PGPASSWORD="iam" psql -h localhost -U groot postgres -c '\l' &> /dev/null; do
  echo >&2 "$(date +%Y%m%dt%H%M%S) Waiting for Postgres to start"
  sleep 1
done

echo 'loading data'
curl https://datatransfer.imfast.io/scfire.dump.sql | PGPASSWORD="root" psql -h localhost -U postgres -d firedata

clear
: 'Ready to go'

