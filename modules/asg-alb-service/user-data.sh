#!/bin/bash

set -e

echo "Hello, World" > index.html
nohup busybox httpd -f -p "${server_port}" &