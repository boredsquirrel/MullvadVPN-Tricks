#!/bin/bash

# This service will start MullvadVPN and connect to the last configured server.
# It should have all abilities like Killswitch that the GUI app has, the daemon should take care of that.
# But it avoids running the Electron app, saving RAM and reducing attack surface.
# On GNOME, there is a Mullvad Extension you can use. Nothing on KDE yet.

sudo cat >> /etc/systemd/system/mullvad-autostart.service <<EOF
[Unit]
Description=Autoconnect MullvadVPN before establishing the network
Before=NetworkManager.service

[Service]
Type=oneshot
ExecStart=/usr/bin/mullvad connect
RemainAfterExit=yes

[Install]
WantedBy=graphical.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable --now mullvad-autostart.service
