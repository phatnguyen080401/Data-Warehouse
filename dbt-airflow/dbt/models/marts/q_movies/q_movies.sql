select * 
from 
  {{ ref("stg_moveies") }}, 
  {{ ref("imdb_weighted_rating") }}
where vote_count >= m;