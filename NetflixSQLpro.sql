

---BUSSINESS PROBLEMS 

--q1)count the number of movies vs tv shows
select*from netflix
select count(*),type
from netflix
group by type

--q2)find out the most common ratting for movies and TV shows
with top as(select 
type,rating,
count(*),
RANK()OVER (PARTITION BY type ORDER BY count(*)DESC )AS ranking
from netflix
group by type,rating)
select *from top
where ranking =1


--q3)list all movies released in a specific year (eg 2002.)
select
title,release_year
from netflix
where type='Movie'
AND
release_year='2020'

--q4)find the top 5 countries having most content on netflix(split if more than one countries are in one cell)
select 
unnest(string_to_array(country,','))as new_country,
count(show_id) as total_count
from netflix
group by 1
order by 2 desc
limit 5;

--q5)identify the longest movie
select*
from netflix
where type='Movie'
AND
duration =(select MAX(duration) from netflix);

--q6)find the content added in 5 years 
select *from
netflix
where 
TO_DATE(date_added,'Month DD ,YYYY') >= CURRENT_DATE - INTERVAL '5 YEARS'


--Q7)Find all the movies /tv shows directe dby 'Rajiv chilaka'
select*from
netflix
where director ILIKE '%Rajiv Chilaka%'


--q8)List all the TV SHOW with more than 5 seasons 
select*from
netflix
where type ='TV Show'
AND
SPLIT_PART(duration,' ',1)::numeric > 5


--q9)count the no of list items in each genre 
select
count(show_id)as total_count,
unnest(string_to_array(listed_in,','))as genre
from netflix
group by 2
order by 1 desc;

--q10)Find each year no of content released by india on netflix order top 5 years with highest
-- avg content release
select
EXTRACT(YEAR FROM TO_DATE(date_added,'Month DD,YYYY')) as year,
COUNT(*),
ROUND(
COUNT(*)::numeric/(SELECT COUNT(*) FROM netflix WHERE country = 'India')::numeric *100
,2) as avg_content
from netflix 
where country ='India'
group by 

--q11)List all the movies that are documentries
select*from netflix
where listed_in ILIKE '%Documentaries%'

--q12)find all movies salman khan aooeared in last 10 years
select*from netflix
where casts ILIKE '%Salman Khan%'
AND 
release_year::numeric > extract(year from current_date) -10


--q13)Find all top 10 characters who have appeared in the highest no of movies appeared in India
select
unnest(string_to_array(casts,',')) as characters,
count(casts) as total_character
from netflix
group by 1
order by 2 desc
limit 10

--q14)categorized the content based on the presence of keyword'killd and violence in the descripiton
--feild .Label content containing these keyword as 'Bed ' and all other as good .count hw many items
--falls into each category-

with new_table AS(select *,
 CASE
     WHEN description ILIKE '%kills%' 
         OR description ILIKE '%violence%' THEN 'Bad_content'
     ELSE 'Good_content'
 END as category
from netflix
)
select
category,
count(category) as total
from new_table
group by 1
