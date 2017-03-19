#!/usr/bin/env bash.origin.script

depend {
    "request": "@../..#s1"
}

CALL_request expect 200 "http://github.com"
