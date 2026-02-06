FROM python:3.13-slim

WORKDIR /app

COPY api/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY api /app/api
COPY drive /app/drive

EXPOSE 8000

CMD ["uvicorn", "api.API:app", "--host", "0.0.0.0", "--port", "8000"]
