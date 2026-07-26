CREATE SCHEMA IF NOT EXISTS raw;
CREATE SCHEMA IF NOT EXISTS validation;
CREATE SCHEMA IF NOT EXISTS analytics;

CREATE TABLE IF NOT EXISTS raw.weather_api_responses (
    id BIGSERIAL PRIMARY KEY,
    source TEXT NOT NULL DEFAULT 'weatherstack',
    location_query TEXT NOT NULL,
    payload JSONB NOT NULL,
    fetched_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    payload_hash TEXT NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS raw.ev_fleet_records (
    vehicle_id TEXT PRIMARY KEY,
    model TEXT NOT NULL,
    region TEXT NOT NULL,
    city TEXT NOT NULL,
    battery_kwh NUMERIC(8,2) NOT NULL,
    rated_efficiency_kwh_per_100km NUMERIC(8,2) NOT NULL,
    observed_efficiency_kwh_per_100km NUMERIC(8,2) NOT NULL,
    odometer_km NUMERIC(12,2) NOT NULL,
    operating_date DATE NOT NULL,
    payload JSONB NOT NULL,
    loaded_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS validation.data_quality_results (
    id BIGSERIAL PRIMARY KEY,
    check_name TEXT NOT NULL,
    layer_name TEXT NOT NULL,
    table_name TEXT NOT NULL,
    status TEXT NOT NULL CHECK (status IN ('pass', 'fail')),
    failed_count INTEGER NOT NULL DEFAULT 0,
    details TEXT,
    checked_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
