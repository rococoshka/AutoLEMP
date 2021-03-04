#!/bin/sh
test "$#" = 1 || {echo "Usage: ${0##*/} site"; exit 1}
SITE = "$1"
