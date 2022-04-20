{% macro trino__type_string() %}
  {{ return('varchar') }}
{% endmacro %}

{% macro trino__hash(field) -%}
    md5(cast({{field}} as varbinary))
{%- endmacro %}

{% macro trino__dateadd(datepart, interval, from_date_or_timestamp) %}

    date_add(
        '{{ datepart }}',
        {{ interval }},
        {{ from_date_or_timestamp }}
        )

{% endmacro %}

{% macro trino__datediff(first_date, second_date, datepart) -%}

    date_diff(
        '{{ datepart }}',
        {{ first_date }},
        {{ second_date }}
        )

{%- endmacro %}

{% macro trino__get_tables_by_pattern_sql(schema_pattern, table_pattern, exclude='', database=target.database) %}

        select distinct
            table_schema as "table_schema",
            table_name as "table_name",
            {{ dbt_utils.get_table_types_sql() }}
        from {{ database }}.information_schema.tables
        where lower(table_schema) like lower('{{ schema_pattern }}')
        and lower(table_name) like lower('{{ table_pattern }}')
        and lower(table_name) not like lower('{{ exclude }}')

{% endmacro %}
