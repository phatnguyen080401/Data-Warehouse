select 
  movie_id, 
  movie_name,
  array_size(parse_json(casts)) as number_of_casts
from 
  {{ ref("stg_credits") }}
order by 3 desc
limit 10;