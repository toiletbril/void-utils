#!/bin/sh

cd "$(dirname "$0")" || exit 1

ln -sfiv "$PWD/bin"/* -t '/usr/local/bin/'
