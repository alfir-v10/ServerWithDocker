#!/bin/bash
service nginx start;
service mysql start;
service php7.3-fpm start
while true; do sleep 10000; done

