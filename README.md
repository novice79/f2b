docker run -d --name f2b --restart always \
  --network host \
  --cap-add NET_ADMIN \
  --cap-add NET_RAW \
  -v /var/log:/var/log:ro \
  novice/f2b