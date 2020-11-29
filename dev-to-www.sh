#!/bin/bash
# NOTICE: run this script as webserver user (sudo -uwww-data)
# this will create missing directories with proper rights

# Make sure only www-data can run our script
if [ "$(id -u -n)" != "www-data" ]; then
   echo "This script must be run as www-data" 1>&2
   exit 1
fi

SRC='xxxx.yousite.com';
DST='www.yousite.com';

printf "\n Replace URL in files \n"

find .  -type d \( \
         -name "wp-snapshots" -o\
         -name "wp-includes" -o \
         -name "wp-admin" -o \
         -name "cache" -o \
         -name "et-cache" -o \
         -name "sitemap-cache" -o \
         -name "languages" -o\
         -name "plugins" -o\
         -name "cache" -o \
         -name "Divi" \) \
         -prune -o \
        -type f -not \( -iname '*.sh' -o \
         -iname '*.js' -o \
         -iname '*.mp4' -o \
         -iname '*.jpg' -o \
         -iname '*.png' -o \
         -iname '401.html' \) \
        -exec grep -q "$SRC" {} \; \
        -exec sed -i 's,'"$SRC"','"$DST"',' {} \; \
        -printf '"%p"\n'

printf "\n Changing Language to DE \n"

wp site switch-language de_DE

printf "\n Encourage search engines from indexing this site \n"

wp option set blog_public 1

printf "\n Replacing $SRC to $DST"
# https://developer.wordpress.org/cli/commands/search-replace/
wp search-replace $SRC $DST --all-tables --report-changed-only # --dry-run

printf "\n Flushing Cache"
wp cache flush

printf "\n Rebuild W3TC Cache"
wp w3-total-cache pgcache_prime
