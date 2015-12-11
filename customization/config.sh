#!/bin/bash

JBOSS_HOME=/opt/jboss/wildfly
JBOSS_CLI=$JBOSS_HOME/bin/jboss-cli.sh
JBOSS_MODE=${1:-"standalone"}
JBOSS_CONFIG=${2:-"$JBOSS_MODE.xml"}

function wait_for_wildfly() {
	until `$JBOSS_CLI -c "ls /deployment" &> /dev/null`; do
		sleep 10
	done
}

echo "Configuring wildfly..."
echo "==> Starting WildFly..."
$JBOSS_HOME/bin/$JBOSS_MODE.sh -c $JBOSS_CONFIG > /dev/null &

echo "==> Waiting..."
wait_for_wildfly

echo "==> Executing..."
$JBOSS_CLI -c --file=`dirname "$0"`/batch.cli  --connect

echo "==> Shutting down WildFly..."
if [ "$JBOSS_MODE" = "standalone" ]; then
	$JBOSS_CLI -c ":shutdown"
else
	$JBOSS_CLI -c "/host=*:shutdown"
fi
echo "Added Postgres-Driver to Wildfly"
