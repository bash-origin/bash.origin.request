#!/usr/bin/env bash.origin.script

depend {
    "request": "bash.origin.request # request/v0"
}

CALL_request expect_status 200 "http://github.com"
