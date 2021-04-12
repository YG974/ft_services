#!/bin/ash

top -n 1 > top.file;
grep "telegraf" top.file ;