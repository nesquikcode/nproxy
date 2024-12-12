FROM ubuntu:24.04

EXPOSE 743/tcp
EXPOSE 543/tcp
EXPOSE 643/tcp

EXPOSE 743/udp
EXPOSE 543/udp
EXPOSE 643/udp

WORKDIR /root
RUN apt update && apt upgrade -y
RUN apt install -y wget curl build-essential libssl-dev zlib1g-dev git make screen python3 vim-common python3-venv python3-pip
RUN git clone https://github.com/TelegramMessenger/MTProxy.git

WORKDIR /root/MTProxy
RUN rm Makefile
ADD Makefile /root/MTProxy/Makefile
RUN make clean && make

WORKDIR /root/MTProxy/objs/bin
RUN mkdir /root/mtproto-proxy
RUN cp mtproto-proxy /root/mtproto-proxy/mtproxy

WORKDIR /root/mtproto-proxy
RUN rm -r /root/MTProxy
RUN curl -s https://core.telegram.org/getProxySecret -o proxy-secret
RUN curl -s https://core.telegram.org/getProxyConfig -o proxy-multi.conf
RUN head -c 16 /dev/urandom | xxd -ps > proxy-secret
RUN echo "./mtproxy -u root -p 743 -S $(cat proxy-secret) --aes-pwd proxy-secret proxy-multi.conf -M 4" > start.sh

WORKDIR /root
RUN python3 -m venv socks5-proxy
RUN python3 -m venv http-proxy
RUN chmod +x socks5-proxy/bin/activate
RUN chmod +x http-proxy/bin/activate
RUN chmod +x mtproto-proxy/start.sh
RUN chmod +x mtproto-proxy/mtproxy
RUN bash -c "source socks5-proxy/bin/activate && pip3 install pysocks5server"
RUN bash -c "source http-proxy/bin/activate && pip3 install pyproxy"

ADD start.sh /start.sh
RUN chmod +x /start.sh

CMD ["/usr/bin/sh", "/start.sh"]