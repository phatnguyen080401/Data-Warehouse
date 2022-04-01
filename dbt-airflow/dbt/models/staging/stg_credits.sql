select
    movie_id,
    title as movie_name,
    cast,
    crew
from 
    {{ ref("tmdb_5000_credits") }}