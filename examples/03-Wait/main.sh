#!/usr/bin/env bash.origin.script

depend {
    "request": "@../..#s1"
}

CALL_request wait 5 200 "https://github.com"

echo "OK"
