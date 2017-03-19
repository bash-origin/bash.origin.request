#!/usr/bin/env bash.origin.script

function EXPORTS_expect {
    local status=$(curl --write-out %{http_code} --silent --output /dev/null "${2}")
    if [ "$status" != "${1}" ]; then
        echo "ERROR: Not Up! Got status $status for url ${2}."
        exit 1
    fi
}
