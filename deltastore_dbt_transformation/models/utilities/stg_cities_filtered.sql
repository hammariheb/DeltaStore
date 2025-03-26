WITH cities_seed AS (
    SELECT DISTINCT 
        state_code,
        state_name,
        country_name 
    FROM {{ ref('cities') }}
    WHERE country_name = 'United States'
)

SELECT *
FROM cities_seed
