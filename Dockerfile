FROM maven:3.9.6-eclipse-temurin-21 AS maven_build

WORKDIR /build

# copy only what the build needs
COPY pom.xml .
COPY keycloak-themes ./keycloak-themes

# package the theme JAR (keycloak-themes/target/keycloak-themes-<version>.jar)
RUN mvn -B clean package

FROM quay.io/keycloak/keycloak:26.7.3 AS builder

ENV KC_HEALTH_ENABLED=true
ENV KC_METRICS_ENABLED=true
ENV KC_FEATURES=token-exchange,admin-fine-grained-authz
ENV QUARKUS_TRANSACTION_MANAGER_ENABLE_RECOVERY=true

ENV KC_DB=mysql

WORKDIR /opt/keycloak

# providers (our theme JAR) must be in place BEFORE kc.sh build
COPY --from=maven_build /build/keycloak-themes/target/keycloak-themes-*.jar /opt/keycloak/providers/

RUN /opt/keycloak/bin/kc.sh build

FROM quay.io/keycloak/keycloak:26.7.3

COPY --from=builder /opt/keycloak/ /opt/keycloak/

ENTRYPOINT ["/opt/keycloak/bin/kc.sh", "start", "--optimized",  "--http-enabled=true", "--proxy-headers=xforwarded"]