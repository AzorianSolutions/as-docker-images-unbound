#!/bin/bash

[ -n "$DEBUG" ] && [ "$DEBUG" -gt 0 ] && set -x

set -eo pipefail

convert_file_vars() {
    for line in $(env)
    do
        if [[ $line == UNBOUND_* ]] || [[ $line == AS_* ]];
        then
            if [[ $line =~ ^.*_FILE ]];
            then
                local INDEX=$( echo $line | grep -aob '=' | grep -oE '[0-9]+')
                local LEN=$( echo $line | wc -c)
                local NAME_END_INDEX=$(($INDEX - 5))
                local NAME_FULL=$( echo $line | cut -c1-$INDEX)
                local NAME=$( echo $line | cut -c1-$NAME_END_INDEX)
                INDEX=$(($INDEX + 2))
                local VALUE=$( echo $line | cut -c$INDEX-$LEN)
                local FILE_VALUE=`cat $VALUE`
                export $NAME=$FILE_VALUE
                unset $NAME_FULL
            fi
        fi
    done
}

# if command starts with an option, prepend the appropriate server command name
if [ "${1:0:1}" = '-' ]; then
	set -- unbound "$@"
fi

# Automatically convert any environment variables that are prefixed with "UNBOUND_" or "AS_" and suffixed with "_FILE"
convert_file_vars

config_file=/etc/unbound/unbound.conf

# Apply appropriate ownership to the PowerDNS config file
chown ${UNBOUND_setuid}:${UNBOUND_setgid} $config_file

exec "$@"
