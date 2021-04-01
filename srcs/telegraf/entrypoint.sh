#!/bin/ash

# TELEGRAF

telegraf -config /etc/telegraf.conf

tail -F /dev/null
