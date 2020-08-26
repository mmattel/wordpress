#!/bin/bash
SRC='dev.innovation-und-beratung.com';
DST='www.innovation-und-beratung.com';
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

printf "\n Changing Language to DE \n"

wp site switch-language de_DE

printf "\n Encourage search engines from indexing this site \n"

wp option set blog_public 1
