#!/usr/bin/env bash.origin.script

depend {
    "request": "@../..#s1"
}

CALL_request expect_status 200 "http://github.com"
