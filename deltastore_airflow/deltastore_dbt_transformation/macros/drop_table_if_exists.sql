{% macro drop_table_if_exists(schema, table) %}
    {% set schema_name = target.schema %}
    {% set sql %}
        IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID( '{{schema_name}}.{{ table }}') AND type = 'U')
        BEGIN
            DROP TABLE {{ schema_name }}.{{ table }};
        END
    {% endset %}
    {{ run_query(sql) }}
{% endmacro %}
