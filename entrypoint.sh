#!/bin/bash
set -e

rm -f /communication_app_back/tmp/pids/server.pid

exec "$@"