#!/bin/bash
SRC='www.yousite.com';
DST='xxxx.yousite.com';

printf "\n Replace URL in files \n"

find .  -type d \( \
         -name "wp-snapshots" -o\
         -name "wp-includes" -o \
         -name "wp-admin" -o \
         -name "cache" -o \
         -name "et-cache" -o \
         -name "sitemap-cache" -o \
         -name "uploads" -o \
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

printf "\n Changing Language to EN \n"

wp site switch-language en_US

printf "\n Discourage search engines from indexing this site \n"

wp option set blog_public 0

printf "\n Replacing $SRC to $DST"
# https://developer.wordpress.org/cli/commands/search-replace/
wp search-replace $SRC $DST --all-tables --report-changed-only # --dry-run

printf "\n Flushing Cache"
wp cache flush

printf "\n Rebuild W3TC Cache"
wp w3-total-cache pgcache_prime
