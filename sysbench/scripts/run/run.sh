#!/bin/bash

for i in {60..0}; do
  if echo 'SELECT 1' | mysql -h${MYSQL_HOST} -u${MYSQL_USER} -p${MYSQL_PASSWORD} ${MYSQL_DB} &> /dev/null; then
    break
  fi
    echo 'MySQL init process in progress...'
    sleep 3
done

if [ $i -eq 0 ] ; then
  echo "Grafana failed to startup" >&2
  exit 1
fi

sysbench --test=/usr/share/doc/sysbench/tests/db/oltp.lua --oltp-table-size=100000 --mysql-host="${MYSQL_HOST}" --mysql-user="${MYSQL_USER}" --mysql-password="${MYSQL_PASSWORD}" --mysql-db="${MYSQL_DB}" prepare
sysbench --num-threads=16 --test=/usr/share/doc/sysbench/tests/db/oltp.lua --oltp-table-size=100000 --mysql-host="${MYSQL_HOST}" --mysql-user="${MYSQL_USER}" --mysql-password="${MYSQL_PASSWORD}" --mysql-db="${MYSQL_DB}" run