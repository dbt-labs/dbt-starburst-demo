{{ dbt_utils.date_spine(
    datepart="day",
    start_date="to_date('01/01/1992', 'mm/dd/yyyy')",
    end_date="date_add(current_date(), 365)"
   )
}}