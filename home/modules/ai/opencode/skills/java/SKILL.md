---
name: java
description: Modern Java (17-21) conventions, build tools (Maven/Gradle), virtual threads, testing with JUnit 5/AssertJ/Testcontainers, and frameworks (Spring Boot 3, Hibernate 6, Quarkus)
license: MIT
compatibility: opencode
metadata:
  language: java
  audience: developers
---

## Build Tools

- **Maven**: `pom.xml` at project root, `mvnw` wrapper, `mvn clean verify`. Use `<properties>` for versions, plugin management in `<pluginManagement>`
- **Gradle**: Kotlin DSL in `build.gradle.kts`, version catalogs in `gradle/libs.versions.toml`, convention plugins in `build-logic`
- Standard layout: `src/main/java/`, `src/main/resources/`, `src/test/java/`, `src/test/resources/`
- Use wrapper scripts (`mvnw`/`gradlew`) committed to repo for CI reproducibility

## Code Conventions

- Oracle / Google Java Style — enforce with Spotless (`spotless:check`) or Checkstyle
- Packages: reverse domain (`com.example.project`), one concept per package
- Class structure: static fields, instance fields, constructors, public API, private helpers
- Records (`record Point(int x, int y)`) for transparent carriers, sealed classes/interfaces for restricted hierarchies
- Pattern matching for `instanceof` (`if (obj instanceof String s)`) and `switch` (`switch (obj) { case String s -> ... }`)
- Switch expressions with `->` over statement switches — no fall-through
- Text blocks (`"""..."""`) for SQL, JSON, HTML templates
- `Optional` for return types only — never for fields, method parameters, or collections

## Modern APIs (Java 17+)

- Sequenced collections: `List.of()`, `Set.of()`, `Map.of()`, `List.copyOf()`, `Stream.toList()`
- `String.repeat()`, `String.stripIndent()`, `String.formatted()`, `"".isBlank()`, `"".lines()`
- `Collectors.teeing()` for bifurcating streams
- `Predicate.not()`, `Objects.requireNonNullElse()`
- `Instant`, `LocalDate`, `LocalDateTime`, `Duration`, `Period` — never `java.util.Date` or `Calendar`

## Performance & Concurrency

- Virtual threads (Loom): `Executors.newVirtualThreadPerTaskExecutor()` for thread-per-request — don't pool them
- `ReentrantLock` over `synchronized` for fine-grained locking
- `ConcurrentHashMap`, `CopyOnWriteArrayList`, `BlockingQueue` for concurrent collections
- Profile with JFR (`-XX:StartFlightRecording`) before optimizing — never guess at bottlenecks
- JMH for microbenchmarking (not `System.currentTimeMillis()` in a loop)

## Testing

- JUnit 5: `@Test`, `@ParameterizedTest` with `@CsvSource`/`@ValueSource`/`@MethodSource`, `@DisplayName` on every test
- AssertJ: fluent assertions (`assertThat(list).extracting(Person::name).containsExactly("Alice", "Bob")`)
- Mockito: `@Mock`, `@InjectMocks`, `@ExtendWith(MockitoExtension.class)`, `BDDMockito.given()`/`then()`
- Testcontainers: `@Testcontainers`, `@Container` for PostgreSQL, Kafka, Redis in integration tests
- ArchUnit: architecture tests for package dependency rules, layer checks
- Structure: every test method follows given/when/then

## Frameworks

- **Spring Boot 3**: constructor injection, `@Configuration` classes, `@ConfigurationProperties(prefix = "...")` with records, `@Service`/`@Repository`/`@Controller`, `application.yml`
- **Hibernate/JPA 6**: `@Entity`, `@Table`, `@Column`, Spring Data JPA `@Repository` with `Specification<T>` for dynamic queries
- **Quarkus**: compile-time metadata, continuous testing (`mvn quarkus:test`), native binaries via GraalVM
- **Jakarta EE 11**: CDI beans, JAX-RS `@Path` resources, `@Stateless` EJBs, JSON Binding
