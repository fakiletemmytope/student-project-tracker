# ---------- Stage 1: build ----------
FROM python:3.13-slim AS builder
WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

# ---------- Stage 2: runtime ----------
FROM python:3.13-slim
WORKDIR /app

# Copy installed packages (and scripts) only
COPY --from=builder /usr/local/ /usr/local/

# Copy application source
COPY --from=builder /app /app

EXPOSE 8000
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
