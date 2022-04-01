select
    budget,
    genres, 
    homepage, 
    id as movie_id, 
    keywords, 
    original_language,
    original_title as original_movie_name, 
    overview, 
    popularity, 
    production_companies,
    production_countries, 
    release_date, 
    revenue, 
    runtime,
    spoken_languages, 
    status, 
    tagline, 
    title as movie_name, 
    vote_average,
    vote_count
from 
    {{ ref("tmdb_5000_movies") }}