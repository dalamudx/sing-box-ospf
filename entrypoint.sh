#!/bin/sh
/usr/bin/envsubst < /app/bird/bird.template > /app/bird/bird.conf
/usr/bin/crontab /app/cron
if [ ! -f /app/bird/routers4.conf ] || [ ! -f /app/bird/routers6.conf ]
then
    touch /app/bird/routes4.conf
    touch /app/bird/routes6.conf
fi
/usr/bin/supervisord -c /etc/supervisord.conf