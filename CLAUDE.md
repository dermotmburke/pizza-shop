# Pizza Shop

Demo application showcasing distributed tracing and log correlation across Spring Boot 4 Kafka microservices using Micrometer and Brave.

## Architecture

Multi-module Maven project (`groupId: io.contino`, version `0.0.1`), Java 25, Spring Boot 4.

### Modules

| Module | Port | Role |
|---|---|---|
| `pizza-shop-models` | — | Shared domain models |
| `pizza-shop-tracing` | — | Shared Brave/Micrometer tracing config (`TracingConfig`) |
| `pizza-shop-web-receiver` | 10010 | HTTP entry point — receives orders, publishes to Kafka |
| `pizza-shop-transformer` | 10011 | Kafka consumer/producer — enriches orders with customer address |
| `pizza-shop-repository` | 10012 | Kafka consumer — persists orders |

### Infrastructure (docker-compose)

- **Kafka** (KRaft mode, no Zookeeper) — `localhost:9092`
- **Kafka UI** — `localhost:9093`
- **Zipkin** — `localhost:9411`
- **Loki + Promtail + Grafana** — Grafana at `localhost:3001` (admin/admin)

Docker images are built with Jib (`eclipse-temurin:25` base) and tagged `<module>:latest`.

## Common Commands

```bash
make up       # install Loki plugin, build all modules, start stack, wait for healthcheck
make down     # stop the stack
make install  # ./mvnw install (builds + Jib docker images)
make test     # send 3 test orders to http://localhost:10010/
make health   # poll until web-receiver actuator is healthy
```

## Build

```bash
./mvnw install          # build all modules and produce Docker images via Jib
./mvnw install -pl pizza-shop-web-receiver   # build a single module
```

The `install` phase triggers Jib's `dockerBuild` goal — Docker must be running.

## Tracing

`pizza-shop-tracing` provides `TracingConfig` — a shared Spring `@Configuration` class that registers `orderId` and `customerId` as Brave baggage fields, propagated through MDC for log correlation. All service modules depend on this library.

Traces are exported to Zipkin via `MANAGEMENT_TRACING_EXPORT_ZIPKIN_ENDPOINT`.

## Key Dependencies

- Spring Boot 4 (web, actuator, kafka, zipkin)
- `micrometer-tracing-bridge-brave`
- Brave baggage / MDC correlation
- Lombok
- Jib Maven Plugin 3.5.1
