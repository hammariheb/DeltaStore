{% macro check_duplicates(table, column) %}
    {% set schema_name = target.schema %}  -- Get the schema dynamically

    SELECT {{ column }}, COUNT(*) AS duplicate_count
    FROM {{ schema_name }}.{{ table }}
    GROUP BY {{ column }}
    HAVING COUNT(*) > 1
{% endmacro %}
