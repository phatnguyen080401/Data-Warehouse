select 
  movie_id, 
  movie_name,
  array_size(parse_json(crews)) as number_of_crews
from 
  {{ ref("stg_credits") }}
order by 3 desc
limit 10