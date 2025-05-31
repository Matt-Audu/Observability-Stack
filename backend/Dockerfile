FROM python:3.10-slim AS builder

RUN apt-get update \
 && apt-get install -y build-essential \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

RUN pip install "poetry==2.1.3"

WORKDIR /app

# Copy only dependency files first for caching
COPY pyproject.toml poetry.lock* /app/

# Install dependencies (including your app package)
RUN poetry config virtualenvs.create false \
 && poetry install --no-interaction --no-ansi --no-root

# Now copy the rest of the application
COPY . /app

# Install your application package
RUN pip install .

RUN chmod +x ./prestart.sh

FROM python:3.10-slim AS runtime

# Install runtime dependencies
RUN apt-get update \
 && apt-get install -y --no-install-recommends libpq5 curl \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy installed packages from builder
COPY --from=builder /usr/local/lib/python3.10/site-packages /usr/local/lib/python3.10/site-packages
COPY --from=builder /usr/local/bin /usr/local/bin
COPY --from=builder /app /app

EXPOSE 8000

HEALTHCHECK CMD curl --fail http://localhost:8000/health || exit 1

CMD ["sh", "-c", "./prestart.sh && uvicorn app.main:app --host 0.0.0.0 --port 8000"]


