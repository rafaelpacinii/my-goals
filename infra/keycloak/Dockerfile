FROM quay.io/keycloak/keycloak:26.8.2
RUN mkdir -p /opt/keycloak/data/h2
COPY --chown=1000:0 goals-realm.json /opt/keycloak/data/import/
