#!/usr/bin/env bash.origin.script

depend {
    "request": "bash.origin.request # request/v0"
}

CALL_request wait 5 200 "https://github.com"

echo "OK"
