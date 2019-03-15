
FROM ubuntu:latest
LABEL maintainer="David <david@cninone.com>"
ARG DEBIAN_FRONTEND=noninteractive

RUN apt update && apt install -y fail2ban iptables inetutils-ping whois ssmtp locales tzdata vim sqlite3 \
    && mkdir -p /var/run/fail2ban /data/db \
    && locale-gen en_US.UTF-8 zh_CN.UTF-8 && update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8

COPY sendmail-common.conf /etc/fail2ban/action.d/sendmail-common.conf
COPY sendmail-whois-lines.conf /etc/fail2ban/action.d/sendmail-whois-lines.conf
COPY init.sh /init.sh

WORKDIR /etc/fail2ban

ENTRYPOINT [ "/init.sh" ]