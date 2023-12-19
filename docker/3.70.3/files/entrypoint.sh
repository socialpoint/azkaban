#!/bin/bash
set -e

eval_template() {
  TEMPLATE=$1
  DEST=$2
  CONTENT="$(< $TEMPLATE)"
  eval echo \""${CONTENT//\"/\\\"}"\" >$DEST
}

COMPONENT="$1"

[[ -z "$COMPONENT" ]] && echo "missing component to init" && exit 1
shift

eval_template /tmp/azkaban.properties.template /opt/azkaban/${COMPONENT}/conf/azkaban.properties
eval_template /tmp/azkaban-users.xml.template /opt/azkaban/${COMPONENT}/conf/azkaban-users.xml
echo "$AZKABAN_SSH_KEY" >/opt/azkaban/id_rsa
unset "AZKABAN_SSH_KEY"
chmod 600 /opt/azkaban/id_rsa

cd "/opt/azkaban/${COMPONENT}"
./bin/internal/internal-start-${COMPONENT}.sh "$@"

sleep 1
pid=$(</opt/azkaban/${COMPONENT}/currentpid)
while [ -d /proc/$pid ]; do sleep 1; done

