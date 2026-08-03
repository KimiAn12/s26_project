# Project Progress

This file tracks small implementation increments and the design reasoning behind them. It is separate from git history so the project can show how the platform evolved.

## 2026-07-26

- Added initial project documentation so the existing pipeline, known gaps, and target architecture are visible before changing runtime behavior.
- Chose Power BI as the planned analytics/dashboard layer based on the project direction.
- Added Docker Compose, Airflow runtime setup, raw Postgres schemas, EV sample ingestion, raw validation, dbt staging/intermediate/analytics models, dbt tests, and Power BI connection guidance.

## Running Anti-Pattern List

- The EV data source is currently a local sample file, which is reproducible but not a real external operational source.
- The Power BI layer is documented but does not include a committed `.pbix` file.
