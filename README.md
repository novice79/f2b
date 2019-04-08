docker run -d --name f2b \
-e F2B_DEST_EMAIL=admin@youremail.com \
-e SSMTP_USER=smtpusername \
-e SSMTP_PASSWORD=smtppassword \
-e SSH_PORT=22 \
-e F2B_SENDERNAME=yourservername \
--network host \
--cap-add NET_ADMIN \
--cap-add NET_RAW \
--restart=always \
-v /var/log:/var/log:ro \
novice/f2b

sudo apt install upx

fail2ban-regex myapp.log "^.*failed_ip: <HOST>.*$"