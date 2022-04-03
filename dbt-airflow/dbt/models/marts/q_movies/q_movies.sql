select * 
from 
  {{ ref("stg_movies") }}
join 
  {{ ref("imdb_weighted_rating") }} 
using (movie_id)
where 
  vote_count >= m