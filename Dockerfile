
FROM ubuntu:latest
LABEL maintainer="David <david@cninone.com>"
ARG DEBIAN_FRONTEND=noninteractive

RUN apt update && apt install -y fail2ban iptables whois ssmtp tzdata

COPY init.sh /init.sh

WORKDIR /etc/fail2ban

ENTRYPOINT [ "/init.sh" ]