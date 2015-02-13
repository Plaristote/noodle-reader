#!/bin/sh

pid_file=$HOME/noodle.pid

kill -INT $(cat $pid_file)
rm $pid_file
server/bin/www
