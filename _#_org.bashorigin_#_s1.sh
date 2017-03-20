#!/usr/bin/env bash.origin.script

function EXPORTS_expect {
    local status=$(curl --write-out %{http_code} --silent --output /dev/null "${2}")
    if [ "$status" != "${1}" ]; then
        echo "ERROR: Got status $status for url ${2} while expecting ${1}."
        exit 1
    fi
}

function EXPORTS_wait {

    if [ ! -e "$__DIRNAME__/node_modules" ]; then
        pushd "$__DIRNAME__" > /dev/null
            BO_run_npm install
        popd > /dev/null
    fi

    BO_run_node --eval '

        const REQUEST = require("$__DIRNAME__/node_modules/request");


        var rules = process.argv.slice(1);

        var options = {};
        if (rules.length >= 3) {
            options.routes = {
                alive: {
                    uri: rules[2],
                    status: rules[1],
                    timeout: rules[0] * 1000
                }
            };
            if (rules[3]) {
                options.routes.alive.expect = rules[3];
            }
        }

        if (typeof options.routes.alive === "string") {
            options.routes.alive = {
                uri: options.routes.alive
            };
        }

        var timeoutInterval = null;
        if (options.routes.alive.timeout) {
            timeoutInterval = setTimeout(function () {
                console.error("ERROR: URL " + options.routes.alive.uri + " not up after", options.routes.alive.timeout);
                process.exit(1);
            }, options.routes.alive.timeout);
        }

        if (process.env.VERBOSE) console.log("options", options);

        var url = options.routes.alive.uri;

        if (options.routes.alive.status) {
            if (process.env.VERBOSE) console.log("Checking url " + url + " for status " + options.routes.alive.status + ".");
        }
        if (options.routes.alive.expect) {
            if (process.env.VERBOSE) console.log("Checking url " + url + " against " + JSON.stringify(options.routes.alive.expect || "") + ".");
        }

        function checkAgain () {
            setTimeout(function () {
                doCheck();
            }, 500);
        }

        function doCheck () {
            return REQUEST({
                method: "GET",
                url: url
            }, function (err, response, body) {
                if (err) {
                    return checkAgain();
                }

                if (options.routes.alive.status) {
  
                    if (process.env.VERBOSE) console.log("options.routes.alive.status", options.routes.alive.status);

                    if (response.statusCode != options.routes.alive.status) {
                        return checkAgain();
                    }
                }

                if (options.routes.alive.expect) {

                    if (process.env.VERBOSE) console.log("response.body", response.body);

                    if (typeof options.routes.alive.expect === "string") {

                        if (response.body !== options.routes.alive.expect) {
                            return checkAgain();
                        }

                    } else {

                        try {

                            response.body = JSON.parse(response.body);

                        } catch (err) {
                            if (process.env.VERBOSE) console.error("Error parsing response JSON to match it to expected value.", err.stack);
                            return checkAgain();
                        }

                        for (var name in options.routes.alive.expect) {
                            if (response[name] !== options.routes.alive.expect[name]) {
                                return checkAgain();
                            }
                        }
                    }
                }

                // All good!
                if (timeoutInterval) {
                    clearInterval(timeoutInterval);
                }
                process.exit(0);
            });
        }

        doCheck();
    ' "$@"
}
