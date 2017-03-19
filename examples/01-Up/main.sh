#!/usr/bin/env bash.origin.script

depend {
    "request": "@../..#s1"
}

CALL_request up "https://github.com"

echo "OK"
