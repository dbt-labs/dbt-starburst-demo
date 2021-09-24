--just using this to show the difference between append and merge 
--(append gets dupes if old records are updated in the seed)

{{
  config(
    materialized='incremental',
    incremental_strategy='append',
    unique_key='id',
    file_format='delta',
    partition_by='date_month'
  )
}}

select 
  id, 
  date_day, 
  date_month
from 
  {{ ref('incremental_seed') }}

{% if is_incremental() %}
  -- this filter will only be applied on an incremental run
  where date_day >= (select max(date_day) from {{ this }})
{% endif %}

order by id asc