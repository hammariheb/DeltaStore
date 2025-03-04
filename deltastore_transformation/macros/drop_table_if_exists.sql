{% macro drop_table_if_exists(schema, table) %}
    {% set sql %}
        IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID('{{ schema }}.{{ table }}') AND type = 'U')
        BEGIN
            DROP TABLE {{ schema }}.{{ table }};
        END
    {% endset %}
    {{ run_query(sql) }}
{% endmacro %}
