{{ config(
    unique_key='id'
)}}

with source as (
    select *
    from {{ source('raw', 'weather_api_responses') }}
),

parsed as (
    select
        id,
        source,
        location_query,
        payload->'location'->>'name' as city,
        payload->'location'->>'country' as country,
        payload->'location'->>'region' as state_or_region,
        nullif(payload->'location'->>'localtime', '')::timestamp as weather_time_local,
        nullif(payload->'location'->>'utc_offset', '')::numeric as utc_offset_hours,
        nullif(payload->'current'->>'temperature', '')::numeric as temperature_c,
        payload->'current'->'weather_descriptions'->>0 as weather_description,
        nullif(payload->'current'->>'wind_speed', '')::numeric as wind_speed_kph,
        nullif(payload->'current'->>'humidity', '')::numeric as humidity_pct,
        nullif(payload->'current'->>'precip', '')::numeric as precipitation_mm,
        fetched_at,
        row_number() over (
            partition by location_query, payload->'location'->>'localtime'
            order by fetched_at desc
        ) as rn
    from source
)

select
    id,
    source,
    location_query,
    city,
    country,
    state_or_region,
    weather_time_local,
    date(weather_time_local) as weather_date,
    utc_offset_hours,
    temperature_c,
    weather_description,
    wind_speed_kph,
    humidity_pct,
    precipitation_mm,
    fetched_at,
    case
        when temperature_c < 0 then 'freezing'
        when temperature_c < 10 then 'cold'
        when temperature_c <= 25 then 'mild'
        else 'hot'
    end as temperature_band
from parsed
where rn = 1
