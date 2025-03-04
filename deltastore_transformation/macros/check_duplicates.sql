{% macro check_duplicates(schema, table, column) %}

    SELECT {{ column }}, COUNT(*) AS duplicate_count
    FROM {{ schema }}.{{ table }}
    GROUP BY {{ column }}
    HAVING COUNT(*) > 1
    
{% endmacro %}
