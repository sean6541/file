#!/usr/bin/env bash

if (( $# == 3 )); then
    if [ "$1" = "gateway" ] || [ "$1" = "g" ]; then
        pppd "$2" "$3" 192.168.4.1:192.168.4.2 lock passive local noauth
        exit 0
    elif [ "$1" = "client" ] || [ "$1" = "c" ]; then
        pppd "$2" "$3" 192.168.4.2:192.168.4.1 lock passive local noauth persist
        exit 0
    fi
fi

cat << "EOF"
Usage:
    ppp.sh <gateway|client> <device> <speed>
EOF
exit 1
