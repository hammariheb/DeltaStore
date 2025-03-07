{% test check_valid_dates(model, column_name) %}

SELECT *
FROM {{ model }}
WHERE {{ column_name }} < CAST('2020-01-01' AS DATE) 
   OR {{ column_name }} > CAST(GETDATE() AS DATE)

{% endtest %}
