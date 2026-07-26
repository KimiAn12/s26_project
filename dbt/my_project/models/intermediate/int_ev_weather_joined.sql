with ev as (
    select *
    from {{ ref('stg_ev_fleet_records') }}
),

weather as (
    select *
    from {{ ref('stg_weather_data') }}
)

select
    ev.vehicle_id,
    ev.model,
    ev.region,
    ev.city,
    ev.battery_kwh,
    ev.rated_efficiency_kwh_per_100km,
    ev.observed_efficiency_kwh_per_100km,
    ev.efficiency_delta_kwh_per_100km,
    ev.efficiency_penalty_pct,
    ev.estimated_range_km,
    ev.odometer_km,
    ev.operating_date,
    weather.weather_time_local,
    weather.temperature_c,
    weather.temperature_band,
    weather.weather_description,
    weather.wind_speed_kph,
    weather.humidity_pct,
    weather.precipitation_mm,
    case
        when weather.temperature_c < 0 then 'high_cold_weather_risk'
        when weather.temperature_c > 30 then 'high_heat_weather_risk'
        when ev.efficiency_penalty_pct >= 25 then 'high_efficiency_penalty'
        when ev.efficiency_penalty_pct >= 10 then 'moderate_efficiency_penalty'
        else 'normal'
    end as operational_risk_label
from ev
left join weather
    on lower(ev.city) = lower(weather.city)
    and ev.operating_date = weather.weather_date
