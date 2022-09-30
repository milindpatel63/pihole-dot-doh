#!/bin/bash
# Creating pihole-dot-doh service
mkdir -p /etc/services.d/pihole-dot-doh/
chmod -R 777 /etc/services.d/pihole-dot-doh/
touch /etc/services.d/pihole-dot-doh/run
# run file
# echo '#!/usr/bin/with-contenv bash' > /etc/services.d/pihole-dot-doh/run
echo '#!/usr/bin/env bash' > /etc/services.d/pihole-dot-doh/run
chmod 777 /etc/services.d/pihole-dot-doh/run
# Copy config file if not exists
echo 'cp -n /temp/stubby.yml /etc/pihole/' >> /etc/services.d/pihole-dot-doh/run
echo 'cp -n /temp/cloudflared.yml /etc/pihole/' >> /etc/services.d/pihole-dot-doh/run
# run stubby in background
echo 's6-echo "Starting stubby"' >> /etc/services.d/pihole-dot-doh/run
echo 'stubby -g -C /etc/pihole/stubby.yml' >> /etc/services.d/pihole-dot-doh/run
# run cloudflared in foreground
echo 's6-echo "Starting cloudflared"' >> /etc/services.d/pihole-dot-doh/run
echo '/usr/local/bin/cloudflared --config /etc/pihole/cloudflared.yml' >> /etc/services.d/pihole-dot-doh/run


# cloudflared tunnel to access pihole webui securely
mkdir -p /etc/services.d/cloudflaredtunnel/
chmod -R 777 /etc/services.d/cloudflaredtunnel/
touch /etc/services.d/cloudflaredtunnel/run
# run file
echo '#!/usr/bin/env bash' > /etc/services.d/cloudflaredtunnel/run
chmod 777 /etc/services.d/cloudflaredtunnel/run
# run cloudflared tunnel in foreground
echo 's6-echo "Starting cloudflared tunnel"' >> /etc/services.d/cloudflaredtunnel/run
echo '/usr/local/bin/cloudflared tunnel --no-autoupdate run --token $TUNNEL_TOKEN' >> /etc/services.d/cloudflaredtunnel/run

# finish file
echo '#!/usr/bin/env bash' > /etc/services.d/pihole-dot-doh/finish
chmod 777 /etc/services.d/pihole-dot-doh/finish
echo 's6-echo "Stopping stubby"' >> /etc/services.d/pihole-dot-doh/finish
echo 'killall -9 stubby' >> /etc/services.d/pihole-dot-doh/finish
echo 's6-echo "Stopping cloudflared"' >> /etc/services.d/pihole-dot-doh/finish
echo 'killall -9 cloudflared' >> /etc/services.d/pihole-dot-doh/finish

# finish file
echo '#!/usr/bin/env bash' > /etc/services.d/cloudflaredtunnel/finish
chmod 777 /etc/services.d/cloudflaredtunnel/finish
echo 's6-echo "Stopping cloudflared"' >> /etc/services.d/cloudflaredtunnel/finish
echo 'killall -9 cloudflared' >> /etc/services.d/cloudflaredtunnel/finish