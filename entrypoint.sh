#!/bin/sh
/usr/bin/envsubst < /app/bird/bird.template > /app/bird/bird.conf
/usr/bin/crontab /app/cron
/usr/bin/supervisord -c /etc/supervisord.conf