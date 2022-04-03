with m as (
    select 
        percentile_cont(0.9) within group(order by vote_count) over () as p
    from 
        {{ ref("stg_movies") }}
    limit 1
),

C as (
    select 
        avg(vote_average) as mean
    from 
        {{ ref("stg_movies") }}
),

vote as (
    select 
        movie_id,
        vote_count,
        vote_average
    from 
        {{ ref("stg_movies") }}
)

select 
    movie_id,
    m.p as m,
    (vote_count / (vote_count + m.p) * vote_average) + (m.p / (m.p + vote_count) * C.mean) as weighted_rating
from 
    m, 
    C, 
    vote