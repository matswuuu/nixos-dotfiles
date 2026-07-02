---
name: python
description: Modern Python (3.12-3.14) — uv, Ruff, mypy/Ty, pytest, src-layout, PEP 695 generics, async patterns, FastAPI/Django/SQLAlchemy 2.0, pydantic v2
license: MIT
compatibility: opencode
metadata:
  language: python
  audience: developers
---

## Package Management

- **uv** (Astral): `uv init`, `uv add fastapi`, `uv sync`, `uv run main.py`, `uv lock` — single Rust binary replaces pip+venv+pip-tools+virtualenv
- `pyproject.toml` (PEP 621) is the single source of truth — no `setup.py`, `setup.cfg`, `requirements.txt` in new projects
- `src/` layout (`src/my_package/`) for import isolation — prevents importing from project root accidentally
- `.venv` at project root, gitignored; `uv venv` creates it
- For existing projects: `uv pip install -r requirements.txt` works as drop-in for pip

## Code Style (Ruff-enforced)

- Ruff replaces flake8, isort, pyupgrade, Black — single `pyproject.toml` config: `[tool.ruff]`
- `ruff check .` — lint (includes all flake8 plugins, pyupgrade, isort)
- `ruff format .` — formatting (Black-compatible, 10-100x faster)
- `ruff check --fix .` — auto-fix many issues
- PEP 8: 4-space indent, blank lines around top-level definitions, 88 char line length (Black default)

## Type Hints

- Type hints on all public function signatures — `def greet(name: str) -> str:`
- Modern syntax (Python 3.9+): `list[X]` over `List[X]`, `dict[K,V]` over `Dict[K,V]`, `tuple[X, ...]` over `Tuple[X, ...]`
- PEP 695 generic syntax (Python 3.12+): `def first[T](items: list[T]) -> T:` — no need for `TypeVar`
- `type` statement (Python 3.12+): `type Vector = list[float]` — simple type aliases without `TypeAlias`
- `Self` type (Python 3.11+): `class Foo: def copy(self) -> Self: ...` — correct return type for chaining/inheritance
- `Optional[X]` ≡ `X | None` — prefer `X | None` syntax (Python 3.10+)
- `Never` for unreachable code, `Literal["a", "b"]` for exact value constraints

## Type Checking

- **mypy**: `mypy . --strict` — enables all strict flags; run in CI
- **Ty** (Astral, new in 2026): faster alternative to mypy, configured in `pyproject.toml`, replaces mypy for many projects
- `pyright` / Pylance: for editor integration; configure `"typeCheckingMode": "strict"` in VS Code

## Async

- `async`/`await` for I/O: HTTP (httpx), databases (asyncpg, aiomysql, redis-py async), file I/O (aiofiles)
- `asyncio.TaskGroup` (3.11+) over `asyncio.gather()` — better cancellation and error propagation
- `asyncio.timeout()` (3.11+) over `asyncio.wait_for()` — context manager, more readable
- `anyio` for cross-framework async: supports both asyncio and trio backends
- `httpx.AsyncClient` over `requests` in new async code — connection pooling, timeouts, retry

## Free-Threaded Python (3.14)

- `--disable-gil` build available (PEP 703) — true parallel execution without GIL
- Not default yet; opt in with `PYTHON_GIL=0` or build Python with `--disable-gil`
- Use `threading` and `concurrent.futures` for CPU-bound parallelism without `multiprocessing` overhead

## Testing

- **pytest**: `pytest -v`, `pytest -x` (fail fast), `pytest --cov=src --cov-report=term-missing`
- Fixtures: `@pytest.fixture` for setup/teardown, `@pytest.mark.parametrize` for data-driven tests
- Mocking: `pytest-mock` — `mocker.patch('module.fn')`, `mocker.AsyncMock()`
- Async: `pytest-asyncio` — `@pytest.mark.asyncio` for async test functions
- Snapshot: `syrupy` for JSON/text snapshot testing
- Property-based: `hypothesis` for fuzzing inputs and finding edge cases

## Frameworks

- **FastAPI**: `APIRouter()` for modular routes, `Depends()` for DI, Pydantic v2 `BaseModel` for schemas, `BackgroundTasks` for post-response work, `HTTPException` for error responses
- **Django 5**: MTV pattern, async ORM queries (`.afirst()`, `.acreate()`, `.afilter()`), class-based views, Ninja API for typed endpoints
- **SQLAlchemy 2.0**: `DeclarativeBase`, `select()` over `session.query()`, async with `asyncpg`, `Alembic` for migrations
- **Litestar**: alternative to FastAPI — DTOs, layered architecture, `@get`/`@post` decorators
- **Pydantic v2**: `BaseModel`, `Field`, `field_validator`/`model_validator`, `ConfigDict`, `TypeAdapter`, `AliasChoices`/`AliasPath`
- **click / typer**: CLI apps — `@app.command()`, automatic help text, argument parsing, shell completion
- **structlog**: structured JSON logging for production (preferred over stdlib `logging`)
