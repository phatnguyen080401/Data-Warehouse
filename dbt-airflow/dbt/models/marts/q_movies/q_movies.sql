select * 
from 
  {{ ref("stg_movies") }}, 
  {{ ref("imdb_weighted_rating") }}
where vote_count >= m;