#!/bin/bash

if [[ $# -eq 0 ]]; then
        /opt/nymphcast/nymphcast_server \
                -a /opt/nymphcast/apps/ \
                -c /opt/nymphcast/nymphcast_audio_config.ini
else
        /opt/nymphcast/nymphcast_server $@
fi

exit $?
