/usr/bin/supervisord -c /etc/supervisord.conf -y 20480 -z 2 -e info
sleep 6
/bin/sh /app/update
/usr/bin/crontab /app/cron
/usr/bin/sing-box run -D /app
