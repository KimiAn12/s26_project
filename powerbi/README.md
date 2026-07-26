# Power BI Consumption Layer

Power BI connects directly to the Postgres analytics schema after the Airflow DAG has run.

## Connection

Use the PostgreSQL connector in Power BI Desktop.

```text
Server: localhost
Database: my_weather_db
Data Connectivity mode: Import
```

For local demo credentials, use the values from `.env.example` unless you changed them in your private `.env`:

```text
User: my_weather_user
Password: my_weather_password
```

Do not commit real database credentials or API keys; keep those in `.env`.

If you run Power BI from another machine, replace `localhost` with the host that exposes Postgres.

## Tables To Import

Import these tables from the `analytics` schema:

```text
analytics.fct_ev_environmental_performance
analytics.mart_region_environment_summary
analytics.mart_charging_planning_signals
```

Optional diagnostic table:

```text
validation.data_quality_results
```

## Suggested Report Pages

### EV Efficiency vs Weather

Use `analytics.fct_ev_environmental_performance`.

Recommended visuals:

- Scatter plot: `temperature_c` vs `observed_efficiency_kwh_per_100km`, legend by `model`.
- Bar chart: average `efficiency_penalty_pct` by `temperature_band`.
- Table: vehicle-level records with `operational_risk_label`.

### Regional Environmental Comparison

Use `analytics.mart_region_environment_summary`.

Recommended visuals:

- Map or filled map by `city`.
- Bar chart: `avg_efficiency_penalty_pct` by `region`.
- Card visuals for `vehicle_count`, `avg_temperature_c`, and `avg_estimated_range_km`.

### Charging Planning Signals

Use `analytics.mart_charging_planning_signals`.

Recommended visuals:

- Matrix by `region`, `city`, and `charging_planning_signal`.
- Conditional formatting for `avg_efficiency_penalty_pct`.
- KPI cards for elevated-risk vehicle counts.

## Suggested DAX Measures

```DAX
Average Efficiency Penalty % =
AVERAGE(fct_ev_environmental_performance[efficiency_penalty_pct])

Average Estimated Range KM =
AVERAGE(fct_ev_environmental_performance[estimated_range_km])

Elevated Risk Vehicles =
CALCULATE(
    DISTINCTCOUNT(fct_ev_environmental_performance[vehicle_id]),
    fct_ev_environmental_performance[operational_risk_label] <> "normal"
)
```

## Refresh Flow

1. Airflow ingests weather and EV data.
2. Raw validation runs.
3. dbt builds analytics tables and runs tests.
4. Refresh the Power BI dataset.
