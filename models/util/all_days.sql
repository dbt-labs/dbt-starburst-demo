with rawdata as (
    with p as (
        select 0 as generated_number union all select 1
    ), unioned as (
    select
    p0.generated_number * pow(2, 0)
     + 
    p1.generated_number * pow(2, 1)
     + 
    p2.generated_number * pow(2, 2)
     + 
    p3.generated_number * pow(2, 3)
     + 
    p4.generated_number * pow(2, 4)
     + 
    p5.generated_number * pow(2, 5)
     + 
    p6.generated_number * pow(2, 6)
     + 
    p7.generated_number * pow(2, 7)
     + 
    p8.generated_number * pow(2, 8)
     + 
    p9.generated_number * pow(2, 9)
     + 
    p10.generated_number * pow(2, 10)
     + 
    p11.generated_number * pow(2, 11)
     + 
    p12.generated_number * pow(2, 12)
     + 
    p13.generated_number * pow(2, 13)
    + 1
    as generated_number
    from
    p as p0
     cross join 
    p as p1
     cross join 
    p as p2
     cross join 
    p as p3
     cross join 
    p as p4
     cross join 
    p as p5
     cross join 
    p as p6
     cross join 
    p as p7
     cross join 
    p as p8
     cross join 
    p as p9
     cross join 
    p as p10
     cross join 
    p as p11
     cross join 
    p as p12
     cross join 
    p as p13
    )
    select *
    from unioned
    where generated_number <= 11110
    order by generated_number
),
all_periods as (
    select (
        to_timestamp(
            to_unix_timestamp(
                date_add(
    coalesce(date(to_date('01/01/1992','mm/dd/yyyy')), nvl2(date(to_date('01/01/1992','mm/dd/yyyy')), assert_true(date(to_date('01/01/1992','mm/dd/yyyy')) is not null), null))
, row_number() over (order by 1) - 1 * 1)
            ) + 
        to_unix_timestamp(
    coalesce(to_timestamp(to_date('01/01/1992','mm/dd/yyyy')), nvl2(to_timestamp(to_date('01/01/1992','mm/dd/yyyy')), assert_true(to_timestamp(to_date('01/01/1992','mm/dd/yyyy')) is not null), null))
)
        - to_unix_timestamp(
    coalesce(date(to_date('01/01/1992','mm/dd/yyyy')), nvl2(date(to_date('01/01/1992','mm/dd/yyyy')), assert_true(date(to_date('01/01/1992','mm/dd/yyyy')) is not null), null))
)
        )
    ) as date_day
    from rawdata
),
filtered as (
    select *
    from all_periods
    where date_day <= date_add(current_date(),365)
)

select * from filtered