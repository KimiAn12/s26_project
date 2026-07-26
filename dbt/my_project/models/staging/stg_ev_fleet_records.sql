{{ config(unique_key='vehicle_id') }}

select
    vehicle_id,
    model,
    region,
    city,
    battery_kwh,
    rated_efficiency_kwh_per_100km,
    observed_efficiency_kwh_per_100km,
    observed_efficiency_kwh_per_100km - rated_efficiency_kwh_per_100km as efficiency_delta_kwh_per_100km,
    round(
        ((observed_efficiency_kwh_per_100km / nullif(rated_efficiency_kwh_per_100km, 0)) - 1) * 100,
        2
    ) as efficiency_penalty_pct,
    round((battery_kwh / nullif(observed_efficiency_kwh_per_100km, 0)) * 100, 1) as estimated_range_km,
    odometer_km,
    operating_date,
    loaded_at
from {{ source('raw', 'ev_fleet_records') }}
