select
    region,
    city,
    operating_date,
    avg_temperature_c,
    avg_efficiency_penalty_pct,
    avg_estimated_range_km,
    elevated_risk_vehicle_count,
    case
        when avg_efficiency_penalty_pct >= 25 or avg_estimated_range_km < 260 then 'prioritize_charging_capacity'
        when avg_efficiency_penalty_pct >= 10 then 'monitor_capacity'
        else 'normal_capacity'
    end as charging_planning_signal
from {{ ref('mart_region_environment_summary') }}
