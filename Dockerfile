FROM eclipse-temurin:21-jre-alpine

RUN apk add -U bash fontconfig curl font-noto font-noto-arabic font-noto-hebrew font-noto-cjk java-cacerts && \
    apk upgrade && \
    rm -rf /var/cache/apk/* && \
    mkdir -p /app/certs && \
    curl https://truststore.pki.rds.amazonaws.com/global/global-bundle.pem -o /app/certs/rds-combined-ca-bundle.pem  && \
    /opt/java/openjdk/bin/keytool -noprompt -import -trustcacerts -alias aws-rds -file /app/certs/rds-combined-ca-bundle.pem -keystore /etc/ssl/certs/java/cacerts -keypass changeit -storepass changeit && \
    curl https://cacerts.digicert.com/DigiCertGlobalRootG2.crt.pem -o /app/certs/DigiCertGlobalRootG2.crt.pem  && \
    /opt/java/openjdk/bin/keytool -noprompt -import -trustcacerts -alias azure-cert -file /app/certs/DigiCertGlobalRootG2.crt.pem -keystore /etc/ssl/certs/java/cacerts -keypass changeit -storepass changeit

ENV FC_LANG=en-US LC_CTYPE=en_US.UTF-8
ENV MB_PLUGINS_DIR=/home/plugins/
ENV MB_DB_FILE=/db/metabase.db

ADD https://downloads.metabase.com/v0.56.11.x/metabase.jar /home
ADD --chmod=744 https://github.com/motherduckdb/metabase_duckdb_driver/releases/download/1.4.1.0/duckdb.metabase-driver.jar /home/plugins/

COPY entrypoint.sh /home/entrypoint.sh
ENTRYPOINT ["/home/entrypoint.sh"]

CMD ["java", "-jar", "/home/metabase.jar"]
