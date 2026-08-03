# Architecture

```text
External Sources
  Weatherstack API or mock weather payload
  Local EV fleet operating sample
        |
        v
Airflow DAG: ev-environmental-intelligence
        |
        v
Postgres raw schema
  raw.weather_api_responses
  raw.ev_fleet_records
        |
        v
Validation schema
  validation.data_quality_results
        |
        v
dbt clean schema
  stg_weather_data
  stg_ev_fleet_records
  int_ev_weather_joined
        |
        v
dbt analytics schema
  fct_ev_environmental_performance
  mart_region_environment_summary
  mart_charging_planning_signals
        |
        v
Power BI
```

## Layer Responsibilities

The raw layer stores source-shaped data. Weather payloads are preserved as JSONB so the project keeps the original API response before transformation.

The validation layer records data quality checks before dbt builds trusted analytics tables.

The dbt clean layer parses, standardizes, deduplicates, and joins source data.

The analytics layer contains Power BI-ready fact and mart tables.
