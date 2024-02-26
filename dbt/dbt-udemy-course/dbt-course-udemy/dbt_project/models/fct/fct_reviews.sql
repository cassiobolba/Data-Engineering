{{
  config(
    materialized = 'incremental',
    on_schema_change='fail' 
    )
}}
-- as to fail if schema changes 


WITH src_reviews AS (
  SELECT * FROM {{ ref('src_reviews') }}
)
SELECT * FROM src_reviews
WHERE review_text is not null

-- condition for the append, just id the review_date in the new rows are greater than the maximum review_date in this model
{% if is_incremental() %}
  AND review_date > (select max(review_date) from {{ this }})
{% endif %}