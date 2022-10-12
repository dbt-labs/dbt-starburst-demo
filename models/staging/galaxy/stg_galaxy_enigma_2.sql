

select
   fips VARCHAR,
   admin2 VARCHAR,
   province_state VARCHAR,
   country_region VARCHAR,
   last_update VARCHAR,
   latitude DOUBLE,
   longitude DOUBLE,
   confirmed INTEGER,
   deaths INTEGER,
   recovered INTEGER,
   active INTEGER,
   combined_key VARCHAR
)
WITH (
   format = 'json',
   EXTERNAL_LOCATION = 's3://covid19-lake/enigma-jhu/json/')
;