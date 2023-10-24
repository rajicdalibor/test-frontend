#!/bin/sh

d=$(printf '\xFF')
NGINX_SUB_FILTER=$(grep -E '^(VITE_)' .env.template | sort | sed -e "s${d}VITE_\([a-zA-Z0-9_]*\)=\(.*\)${d}sub_filter\ \"NGINX_REPLACE_\1\" \"$\{\1\}\";${d}")
sed -e "s${d}LOCATION_SUB_FILTER${d}$(echo $NGINX_SUB_FILTER)${d}" /etc/nginx/conf.d/configfile.template >/etc/nginx/conf.d/configfile_with_sub_filter.template

# This is a hack around the envsubst nginx config. Because we have `$uri` set
# up, it would replace this as well. Now we just reset it to its original value.
export uri="\$uri"
envsubst </etc/nginx/conf.d/configfile_with_sub_filter.template >/etc/nginx/conf.d/default.conf
bash generate-env-file.sh /usr/share/nginx/html/env.js

[ -z "$@" ] && nginx -g 'daemon off;' || $@
