#!/bin/bash

# Creating pihole-dot-doh service
mkdir -p /etc/services.d/pihole-dot-doh
chmod -R 777 /etc/services.d/pihole-dot-doh
touch /etc/services.d/pihole-dot-doh/run
# run file
# echo '#!/usr/bin/with-contenv bash' > /etc/services.d/pihole-dot-doh/run
echo '#!/usr/bin/env bash' > /etc/services.d/pihole-dot-doh/run
# Copy config file if not exists
echo 'cp -n /temp/stubby.yml /etc/pihole/' >> /etc/services.d/pihole-dot-doh/run
echo 'cp -n /temp/cloudflared.yml /etc/pihole/' >> /etc/services.d/pihole-dot-doh/run
# run stubby in background
echo 's6-echo "Starting stubby"' >> /etc/services.d/pihole-dot-doh/run
echo 'stubby -g -C /etc/pihole/stubby.yml' >> /etc/services.d/pihole-dot-doh/run
# run cloudflared in foreground
echo 's6-echo "Starting cloudflared"' >> /etc/services.d/pihole-dot-doh/run
echo '/usr/local/bin/cloudflared --config /etc/pihole/cloudflared.yml' >> /etc/services.d/pihole-dot-doh/run

# finish file
echo '#!/usr/bin/env bash' > /etc/services.d/pihole-dot-doh/finish
echo 's6-echo "Stopping stubby"' >> /etc/services.d/pihole-dot-doh/finish
echo 'killall -9 stubby' >> /etc/services.d/pihole-dot-doh/finish
echo 's6-echo "Stopping cloudflared"' >> /etc/services.d/pihole-dot-doh/finish
echo 'killall -9 cloudflared' >> /etc/services.d/pihole-dot-doh/finish
