---
name: kotlin
description: Modern Kotlin (K2 compiler) conventions, coroutines/Flow, Gradle Kotlin DSL with version catalogs, testing with Kotest/MockK/Turbine, and frameworks (Ktor, kotlinx.serialization, Compose Multiplatform)
license: MIT
compatibility: opencode
metadata:
  language: kotlin
  audience: developers
---

## Build Tools

- **Gradle Kotlin DSL**: `build.gradle.kts` at project root — never Groovy in new projects
- Version catalogs in `gradle/libs.versions.toml` for centralized dependency management
- Convention plugins (`build-logic/src/main/kotlin`) for shared configuration across modules
- K2 compiler enabled by default in Kotlin 2.x — use `kotlin("jvm")`, `kotlin("plugin.spring")`, `kotlin("plugin.serialization")` plugins
- Use `gradle wrapper` and commit `gradlew`/`gradlew.bat`

## Code Conventions

- Official Kotlin Coding Conventions — enforce with `ktlint` or `diktat`
- `val` by default, `var` only when state mutation is required
- Data classes for value objects, `sealed interface` / `sealed class` for finite type hierarchies
- Extension functions for utility APIs — scope to the receiving type
- `@JvmInline value class` for type-safe wrappers around primitives (e.g., `value class UserId(val value: Long)`)
- `Result<T>` for predictable failures; throw exceptions only for programmer errors (not control flow)
- `require()` / `check()` for preconditions, `error()` for unreachable states
- Prefer functional constructs: `map`/`filter`/`let`/`apply`/`run`/`also` over imperative loops
- Destructuring declarations for data classes and `Pair`/`Triple`

## Coroutines

- `suspend` functions for all async operations — never expose raw `CompletableFuture` or callbacks
- `Flow<T>` for cold async streams, `StateFlow<T>` / `SharedFlow<T>` for observable state
- `coroutineScope`, `supervisorScope`, `withContext` for structured concurrency
- `Dispatchers.IO` for blocking I/O, `Dispatchers.Default` for CPU work, `Dispatchers.Main` for UI
- `launch` for fire-and-forget, `async`/`await` for parallel decomposition
- `flowOn(Dispatchers.IO)` / `flowOn(Dispatchers.Default)` for upstream computation
- `Job` / `SupervisorJob` for lifecycle management — cancel when no longer needed
- Avoid `GlobalScope` — always provide a scope or use `coroutineScope`

## Testing

- **Kotest**: `DescribeSpec` (BDD-style), `StringSpec` (simple), `Should` / `shouldBe` assertions
- **MockK**: `mockk<T>()`, `every { } returns`, `coEvery { } coReturns`, `verify { }`, `coVerify { }` — never Mockito with Kotlin
- Coroutine testing: `runTest { }`, `TestCoroutineScheduler`, `UnconfinedTestDispatcher`
- `Turbine` library: `testScope { testScheduler.advanceTimeBy(...) }`
- `kotlinx-kotest-property` for property-based testing

## Frameworks

- **Ktor 3**: `routing { }` DSL, `HttpClient` with pluggable engines (OkHttp, CIO, Java), content negotiation with kotlinx.serialization, `StatusPages` for error handling
- **kotlinx.serialization**: `@Serializable`, `@SerialName`, `Json { ignoreUnknownKeys = true; isLenient = true; prettyPrint = true }`
- **Spring Boot**: works with Kotlin; prefer constructor-based beans, avoid Kotlin `open` issues with `all-open` plugin
- **Compose Multiplatform**: shared UI targeting Android, Desktop (JVM), Web (JS/Wasm), iOS
- **Arrow**: `Either<Problem, T>`, `Option<T>`, `IO<T>` for functional effect handling
