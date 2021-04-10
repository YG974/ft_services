#!/bin/ash

top -n 1 > top.file;
grep "/usr/sbin/grafana-server" top.file ;