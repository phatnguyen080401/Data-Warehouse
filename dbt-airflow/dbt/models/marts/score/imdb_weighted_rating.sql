set m = (
    select percentile_cont(0.9) within group(order by vote_count) over () as p
    from {{ ref("stg_movies") }}
    limit 1
);
    
set C = (
    select avg(vote_average) 
    from {{ ref("stg_movies") }}
);

with score as (
    select 
        movie_id,
        (vote_count / (vote_count + $m) * vote_average) + ($m / ($m + vote_count) * $C) as weighted_rating
    from {{ ref("stg_movies") }}
);

select 
    $m as m, 
    $C as C, 
    movie_id,
    weighted_rating
from score;