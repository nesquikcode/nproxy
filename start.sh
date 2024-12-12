#!/bin/bash

screen -d -m -S http-proxy bash -c "source /root/http-proxy/bin/activate && pyproxy --bind=0.0.0.0 --port=543 --username=public --password=public"
screen -d -m -S socks5-proxy bash -c "source /root/socks5-proxy/bin/activate && python -m socks5server --host 0.0.0.0 --port 643 --users public:public"
screen -d -m -S mtproto-proxy bash -c "cd /root/mtproto-proxy && ./start.sh"
echo "[*] Proxy servers started."
echo "[MTPROTO] Port: 743, Secret: $(cat /root/mtproto-proxy/proxy-secret)"
echo "[MTPROTO] Link: tg://proxy?server=127.0.0.1&port=743&secret=$(cat /root/mtproto-proxy/proxy-secret)"
echo "[SOCKS5] Port: 643, Username: public, Password: public"
echo "[HTTP] Port: 543, Username: public, Password: public"
echo "Container running loop."
tail -f /dev/null
echo END