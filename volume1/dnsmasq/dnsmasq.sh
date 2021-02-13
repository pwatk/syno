#!/bin/sh

PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/syno/sbin:/usr/syno/bin

test -x /bin/dnsmasq || exit 1

user="dnsmasq"
conf="/volume1/dnsmasq/dnsmasq.conf"
pid="/volume1/dnsmasq/dnsmasq/dnsmasq.pid"
leases="/volume1/dnsmasq/dnsmasq.leases"
log="/volume1/dnsmasq/dnsmasq.log"

start_service() {
  dnsmasq --local-service \
    --user="$user" \
    --conf-file="$conf" \
    --pid-file="$pid" \
    --dhcp-leasefile="$leases" \
    --log-facility="$log"
}

case "$1" in
    start)
      start_service
      ;;
    stop)
      kill -s TERM `cat $pid`
      ;;
    restart)
      kill -s TERM `cat $pid`
      sleep 10
      start_service
      ;;
    status)
      kill -s USR1 `cat $pid`
      ;;
    *)
      echo "Usage: $0 [start|stop|restart|status]"
      ;;
esac

exit 0
