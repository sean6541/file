#!/usr/bin/env bash

if (( $# == 3 )) && [[ "$1" = "gateway" || "$1" = "client" ]]; then
    addrs="192.168.4.1:192.168.4.2"
    if [ "$1" = "client" ]; then addrs="192.168.4.2:192.168.4.1"; fi
    pppd "$2" "$3" "$addrs" lock passive local noauth nocrtscts persist
    exit 0
fi

cat << "EOF"
Usage:
    ppp.sh <gateway|client> <device> <speed>
EOF
exit 1
