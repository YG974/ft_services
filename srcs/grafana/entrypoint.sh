#!/bin/ash

# GRAFANA

cd /usr/share/grafana
exec /usr/sbin/grafana-server

tail -F /dev/null
