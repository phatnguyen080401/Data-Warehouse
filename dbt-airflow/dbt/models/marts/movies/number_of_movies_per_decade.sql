select 
  floor((date_part('year', RELEASE_DATE))/10)*10 as decade, 
  count(id) as number_of_movies
from 
  {{ ref("stg_moveies") }}
group by 1
order by 1;