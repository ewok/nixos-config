#!/usr/bin/env bash

# Create the local nvim-data directories if they don't exist
mkdir -p "/tmp/nvim-data"
mkdir -p "${PWD}/config"
mkdir -p "/tmp/cache"

# Set the XDG environment variables to use the local nvim-data directory
export XDG_DATA_HOME="/tmp/nvim-data"
export XDG_CONFIG_HOME="${PWD}/config"
export XDG_CACHE_HOME="/tmp/cache"

if [ "$1" == "--clean" ]; then
	rm -rf /tmp/nvim-data
	rm -rf /tmp/cache
	rm -f ./config/nvim/lazy-lock.json
else
	nvim "$@"
fi
