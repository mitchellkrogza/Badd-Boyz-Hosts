#!/bin/bash
# Ping Testing Script for Badd Boyz Hosts to check if Hosts file is working
#result=$(ping -c 4 zx6.ru &> /dev/stderr)
#if [ -n "$result" ]
#then
#  logger -t $LOGGER_TAG "Cannot create backup directory in $FINAL_BACKUP_DIR. Backup canceling: $result"
#  exit 1
#fi
for I in {1..5}; do
    if ping -nq -w5 -c1 000free.us | fgrep -q '127.0.0.1'; then
        echo "Hosts File Working"
        exit 0
    else
        echo "Hosts File NOT Working"
        exit 1
    fi

    if ping -nq -w5 -c1 fix-website-errors.com | fgrep -q '127.0.0.1'; then
        echo "Hosts File Working"
        exit 0
    else
        echo "Hosts File NOT Working"
        exit 1
    fi

    if ping -nq -w5 -c1 get-seo-domain.com | fgrep -q '127.0.0.1'; then
        echo "Hosts File Working"
        exit 0
    else
        echo "Hosts File NOT Working"
        exit 1
    fi

    if ping -nq -w5 -c1 olympescort.com | fgrep -q '127.0.0.1'; then
        echo "Hosts File Working"
        exit 0
    else
        echo "Hosts File NOT Working"
        exit 1
    fi

    if ping -nq -w5 -c1 zx6.ru | fgrep -q '127.0.0.1'; then
        echo "Hosts File Working"
        exit 0
    else
        echo "Hosts File NOT Working"
        exit 1
    fi

done
