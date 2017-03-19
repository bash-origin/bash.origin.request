#!/usr/bin/env bash.origin.script

function EXPORTS_up {
    local status=$(curl --write-out %{http_code} --silent --output /dev/null "$1")
    if [ "$status" != "200" ]; then
        echo "ERROR: Not Up! Got status $status for url ${1}."
        exit 1
    fi
}
