# EV Environmental Intelligence Platform

This repository is an end-to-end data engineering project for EV environmental intelligence. It ingests weather and EV operating data, validates raw inputs, transforms them with dbt, and exposes analytics-ready Postgres tables for Power BI.

## Current Architecture

```text
Weather API or mock weather payload + EV fleet sample
        |
        v
Airflow-orchestrated Python ingestion
        |
        v
Postgres raw schema
        |
        v
Validation checks
        |
        v
dbt staging, intermediate, and analytics models
        |
        v
Power BI dashboard layer
```

## Current Project Structure

```text
airflow/
  orchestrator.py              Airflow DAG for ingestion, validation, dbt run, and dbt test

api-request/
  api_request.py               Weatherstack API client and mock weather generator
  insert_records.py            Loads raw weather payloads and EV records
  validate_raw_data.py         Raw data quality checks

data/
  ev/
    fleet_operations_sample.json

dbt/
  profiles.yml                 dbt Postgres connection profile
  my_project/
    models/
      sources/                 dbt source definitions
      staging/                 cleaned source models
      intermediate/            joined EV/weather models
      analytics/               Power BI-ready marts

docker/
  airflow.Dockerfile           Airflow image with project dependencies

powerbi/
  README.md                    Power BI connection and report guidance

postgres/
  init_my_weather_db.sql       schema and raw table bootstrap SQL
```

## What Works

- Docker Compose starts Postgres and Airflow.
- Weather ingestion can use a mock source or the live Weatherstack API.
- EV operating records are loaded from a local versioned sample file.
- Raw data lands in Postgres schemas without immediately discarding source shape.
- Validation checks write results to `validation.data_quality_results`.
- dbt builds clean staging models, an EV/weather joined model, and analytics marts.
- dbt tests protect key identifiers and required fields.
- Power BI can connect to the Postgres analytics schema.

## Quick Start

1. Create a local environment file:

```powershell
Copy-Item .env.example .env
```

2. Keep `USE_MOCK_WEATHER=true` for a no-API-key demo, or set `USE_MOCK_WEATHER=false` and provide `WEATHERSTACK_API_KEY`.

3. Start the platform:

```powershell
docker compose up --build
```

4. Open Airflow:

```text
http://localhost:8080
username/password: use `AIRFLOW_ADMIN_USERNAME` and `AIRFLOW_ADMIN_PASSWORD` from your private `.env`
```

5. Trigger the `ev-environmental-intelligence` DAG.

6. Connect Power BI Desktop to Postgres using the guide in `powerbi/README.md`.

## Core Tables

Raw:

```sql
raw.weather_api_responses
raw.ev_fleet_records
```

Validation:

```sql
validation.data_quality_results
```

Analytics:

```sql
analytics.fct_ev_environmental_performance
analytics.mart_region_environment_summary
analytics.mart_charging_planning_signals
```

## Local Commands

Run Python unit tests:

```powershell
pytest
```

Run dbt manually from inside a configured environment:

```powershell
cd dbt/my_project
dbt run --profiles-dir ..
dbt test --profiles-dir ..
```
