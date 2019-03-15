
FROM ubuntu:latest
LABEL maintainer="David <david@cninone.com>"
ARG DEBIAN_FRONTEND=noninteractive

RUN apt update && apt install -y fail2ban iptables inetutils-ping whois ssmtp tzdata vim sqlite3 \
    && mkdir -p /var/run/fail2ban /data/db

COPY init.sh /init.sh

WORKDIR /etc/fail2ban

ENTRYPOINT [ "/init.sh" ]