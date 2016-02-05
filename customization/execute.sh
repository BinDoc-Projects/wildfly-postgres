#!/bin/bash

JBOSS_HOME=/opt/jboss/wildfly
JBOSS_CLI=$JBOSS_HOME/bin/jboss-cli.sh
JBOSS_MODE=${1:-"standalone"}
JBOSS_CONFIG=${2:-"$JBOSS_MODE.xml"}
JBOSS_DEPLOYMENT=$JBOSS_HOME/$JBOSS_MODE/deployments

function wait_for_server() {
  until `$JBOSS_CLI -c ":read-attribute(name=server-state)" 2> /dev/null | grep -q running`; do
    sleep 5
  done
}

for f in $JBOSS_DEPLOYMENT/*
do
	touch $f.skipdeploy
done

echo "=> Starting WildFly server"
$JBOSS_HOME/bin/$JBOSS_MODE.sh -b 0.0.0.0 -c $JBOSS_CONFIG &

echo "=> Waiting for the server to boot"
wait_for_server

echo "=> Executing the commands"
echo "=> Postgres (docker host): " $POSTGRES_PORT_5432_TCP_ADDR
echo "=> Postgres (docker port): " $POSTGRES_PORT_5432_TCP_PORT

$JBOSS_CLI -c << EOF
xa-data-source remove --name=PostgresXADS

xa-data-source add --name=PostgresXADS --driver-name=postgresql --jndi-name="java:jboss/datasources/postgres" --enabled=true --use-ccm=true --user-name=postgres --xa-datasource-class=org.postgresql.xa.PGXADataSource --xa-datasource-properties=[{url=jdbc:postgresql://$POSTGRES_PORT_5432_TCP_ADDR:$POSTGRES_PORT_5432_TCP_PORT/bda_benchmarking}]

EOF

echo "=> Shutting down WildFly"
if [ "$JBOSS_MODE" = "standalone" ]; then
  $JBOSS_CLI -c ":shutdown"
else
  $JBOSS_CLI -c "/host=*:shutdown"
fi

rm $JBOSS_DEPLOYMENT/*.skipdeploy

echo "=> Restarting WildFly"
$JBOSS_HOME/bin/$JBOSS_MODE.sh -b 0.0.0.0 -c $JBOSS_CONFIG

