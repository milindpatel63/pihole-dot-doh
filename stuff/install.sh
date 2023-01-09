#!/bin/bash
## Piggy-backing on lighttpd service ##
# (/i insert above, /a insert below) #
# Avoid pihole service due to the need to restart for every config change #
# Insert run lines above the call lighttpd comment
sed -i "/^lighttpd /i cp -n \/temp\/stubby.yml \/config/" /etc/s6-overlay/s6-rc.d/lighttpd/run
sed -i "/^lighttpd /i cp -n \/temp\/cloudflared.yml \/config/" /etc/s6-overlay/s6-rc.d/lighttpd/run
sed -i "/^lighttpd /i stubby -g -C \/config\/stubby.yml" /etc/s6-overlay/s6-rc.d/lighttpd/run
sed -i "/^lighttpd /i start-stop-daemon --start --background --name cloudflared --chdir \/config --exec \/usr\/local\/bin\/cloudflared -- --config \/config\/cloudflared.yml" /etc/s6-overlay/s6-rc.d/lighttpd/run

# Insert finish lines above kill
sed -i "/^killall -9 lighttpd/i killall cloudflared" /etc/s6-overlay/s6-rc.d/lighttpd/finish
sed -i "/^killall -9 lighttpd/i killall stubby" /etc/s6-overlay/s6-rc.d/lighttpd/finish


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

# to fix "reducing DNS packet size for nameserver" error
mkdir -p /etc/dnsmasq.d/
touch /etc/dnsmasq.d/99-edns.conf
echo 'edns-packet-max=1232' > /etc/dnsmasq.d/99-edns.conf
chmod 644 /etc/dnsmasq.d/99-edns.conf

# finish file
echo '#!/usr/bin/env bash' > /etc/services.d/cloudflaredtunnel/finish
chmod 777 /etc/services.d/cloudflaredtunnel/finish
echo 's6-echo "Stopping cloudflared"' >> /etc/services.d/cloudflaredtunnel/finish
echo 'killall -9 cloudflared' >> /etc/services.d/cloudflaredtunnel/finish