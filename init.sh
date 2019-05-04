#!/bin/bash
log () {
    printf "[%(%Y-%m-%d %T)T] %s\n" -1 "$*"
}
# set -x
# Timezone
log "TZ=${TZ:=Asia/Chongqing}"
echo "Setting timezone to ${TZ}..."
ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime
echo ${TZ} > /etc/timezone

log "These environment variables, that you can customize via -e"
log "SSMTP_PORT=${SSMTP_PORT:=587}"
log "SSMTP_HOST=${SSMTP_HOST:=smtp.exmail.qq.com}"
HOSTNAME=$(hostname)
log "SSMTP_USER=${SSMTP_USER:=david}"
log "SSMTP_PASSWORD=${SSMTP_PASSWORD:=freego}"

log "F2B_IPTABLES_CHAIN=${F2B_IPTABLES_CHAIN:=DOCKER-USER}"
log "F2B_LOG_LEVEL=${F2B_LOG_LEVEL:=INFO}"
log "F2B_DB_PURGE_AGE=${F2B_DB_PURGE_AGE:=1d}"
log "F2B_MAX_RETRY=${F2B_MAX_RETRY:=3}"
log "F2B_DEST_EMAIL=${F2B_DEST_EMAIL:=david@cninone.com}"
log "F2B_SENDERNAME=${F2B_SENDERNAME:=${HOSTNAME}}"
log "F2B_ACTION=${F2B_ACTION:=%(action_mwl)s}"

log "SSH_PORT=${SSH_PORT:=22}"

cat <<EOT > /etc/ssmtp/ssmtp.conf
UseTLS=YES
UseSTARTTLS=YES
root=${SSMTP_USER}
mailhub=${SSMTP_HOST}:${SSMTP_PORT}
AuthUser=${SSMTP_USER}
AuthPass=${SSMTP_PASSWORD}
FromLineOverride=YES
hostname=${HOSTNAME}
EOT
log "Setting Fail2ban configuration..."
sed -i "s/logtarget =.*/logtarget = STDOUT/g" /etc/fail2ban/fail2ban.conf
sed -i "s/loglevel =.*/loglevel = $F2B_LOG_LEVEL/g" /etc/fail2ban/fail2ban.conf
sed -i "s/dbfile =.*/dbfile = \/data\/db\/fail2ban\.sqlite3/g" /etc/fail2ban/fail2ban.conf
sed -i "s/dbpurgeage =.*/dbpurgeage = $F2B_DB_PURGE_AGE/g" /etc/fail2ban/fail2ban.conf

cat > /etc/fail2ban/filter.d/nb.conf <<EOL
[INCLUDES]
[Definition]
failregex = ^.*failed_ip: <HOST>.*$
ignoreregex =

EOL

cat > /etc/fail2ban/jail.local <<EOL
[DEFAULT]
bantime  = 7200
maxretry = ${F2B_MAX_RETRY}
sender = ${SSMTP_USER}
destemail = ${F2B_DEST_EMAIL}
action = ${F2B_ACTION}[sendername="${F2B_SENDERNAME}"]

[nb]
enabled  = true
port     = http,https
chain    =${F2B_IPTABLES_CHAIN}
filter   = nb
logpath  = /data/db/novice-ban.log
maxretry = 3
findtime = 300

[sshd]
port     = ${SSH_PORT}
EOL

fail2ban-server -x -v start

/main