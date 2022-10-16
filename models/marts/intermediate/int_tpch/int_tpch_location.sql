{{ config(tags = ['location']) }}

with nation as (
    
    select * from {{ ref('stg_tpch_nations') }}

),
region as (
    
    select * from {{ ref('stg_tpch_regions') }}

),

final as (
    nation.nation_key,
    nation.name,
    nation.region_key,
    region.name
    from
        nation
        inner join region
            on nation.region_key = region.region_key
)
select
    *
from
    final
order by
    nation_key