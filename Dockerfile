FROM novice/build:latest as my_build
WORKDIR /workspace
COPY main.py /workspace/main.py
RUN pyinstaller -s -F main.py

FROM ubuntu:latest
LABEL maintainer="David <david@cninone.com>"
ARG DEBIAN_FRONTEND=noninteractive

RUN apt update && apt install -y fail2ban iptables inetutils-ping whois ssmtp locales tzdata vim sqlite3 \
    && mkdir -p /var/run/fail2ban /data/db && touch /data/db/novice-ban.log \
    && locale-gen en_US.UTF-8 zh_CN.UTF-8 && update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8   

COPY sendmail-common.conf /etc/fail2ban/action.d/sendmail-common.conf
COPY sendmail-whois-lines.conf /etc/fail2ban/action.d/sendmail-whois-lines.conf

COPY init.sh /init.sh

COPY --from=my_build /workspace/dist/main /main

WORKDIR /etc/fail2ban

ENTRYPOINT [ "/init.sh" ]