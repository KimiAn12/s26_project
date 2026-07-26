select
    region,
    city,
    operating_date,
    count(distinct vehicle_id) as vehicle_count,
    round(avg(temperature_c), 2) as avg_temperature_c,
    round(avg(observed_efficiency_kwh_per_100km), 2) as avg_observed_efficiency_kwh_per_100km,
    round(avg(efficiency_penalty_pct), 2) as avg_efficiency_penalty_pct,
    round(avg(estimated_range_km), 1) as avg_estimated_range_km,
    count(*) filter (where operational_risk_label <> 'normal') as elevated_risk_vehicle_count
from {{ ref('fct_ev_environmental_performance') }}
group by
    region,
    city,
    operating_date
