select
    movie_id,
    title as movie_name,
    c.cast as casts,
    crew as crews
from 
    {{ ref("tmdb_5000_credits") }} c