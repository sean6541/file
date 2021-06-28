#!/usr/bin/env bash
# Setup fresh Ubuntu installation on laptop ASUS GL703VD

if grep -q '^GRUB_CMDLINE_LINUX=""' /etc/default/grub; then
    sed -i -r 's/^GRUB_CMDLINE_LINUX=""/GRUB_CMDLINE_LINUX="nouveau.blacklist=1"/' /etc/default/grub
elif grep -q '^GRUB_CMDLINE_LINUX=".*"' /etc/default/grub; then
    sed -i -r 's/^GRUB_CMDLINE_LINUX="(.*)"/GRUB_CMDLINE_LINUX="\1 nouveau.blacklist=1"/' /etc/default/grub
else
    sed -i -r '$ a GRUB_CMDLINE_LINUX="nouveau.blacklist=1"' /etc/default/grub
fi
update-grub
prime-select intel
sed -i -r 's/^(%(admin|sudo).*)ALL/\1NOPASSWD: ALL/' /etc/sudoers
cat << "EOF" > /etc/polkit-1/localauthority/50-local.d/99-nopassword.pkla
[No password prompt]
Identity=unix-group:sudo
Action=*
ResultActive=yes
EOF
apt-get update
apt-get -y install cpufrequtils indicator-cpufreq
echo 'GOVERNOR="performance"' > /etc/default/cpufrequtils
cat << "EOF" > /etc/systemd/system/performance.service
[Unit]
Description=devmon

[Service]
User=root
Group=root
Type=simple
ExecStart=gdbus call --system --dest net.hadess.PowerProfiles --object-path /net/hadess/PowerProfiles --method org.freedesktop.DBus.Properties.Set 'net.hadess.PowerProfiles' 'ActiveProfile' "<'performance'>"

[Install]
WantedBy=multi-user.target
EOF
systemctl daemon-reload
systemctl enable performance.service
