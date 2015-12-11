FROM jboss/wildfly

RUN curl -o /tmp/psql-jdbc.jar https://jdbc.postgresql.org/download/postgresql-9.4-1201.jdbc41.jar

ENV JBOSS_HOME /opt/jboss/wildfly

RUN /opt/jboss/wildfly/bin/add-user.sh admin admin --silent

ADD customization /opt/jboss/wildfly/customization

RUN ["sh", "/opt/jboss/wildfly/customization/config.sh"]

RUN rm -rf /opt/jboss/wildfly/standalone/configuration/standalone_xml_history/current

EXPOSE 8080 8080

CMD ["/opt/jboss/wildfly/customization/execute.sh"]
