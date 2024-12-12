#!/bin/bash

screen -d -m -S http-proxy bash -c "source /root/http-proxy/bin/activate && pyproxy --bind=0.0.0.0 --port=543 --username=public --password=public"
screen -d -m -S socks5-proxy bash -c "source /root/socks5-proxy/bin/activate && python -m socks5server --host 0.0.0.0 --port 643 --users public:pblic"
screen -d -m -S mtproto-proxy bash -c "cd /root/mtproto-proxy && ./start.sh"
tail -f /dev/null
echo END