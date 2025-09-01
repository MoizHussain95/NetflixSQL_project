# Netflix Tv Shows and Moivies Data Analysis Using SQL

## Objective  
The objective of this project is to analyze the Netflix dataset using SQL queries to answer different business and analytical questions.  

---

## Queries  

### Q1) Count the number of Movies vs TV Shows  
```sql
select * from netflix;
select count(*), type
from netflix
group by type;
```

### Q2) Find out the most common rating for Movies and TV Shows  
```sql
with top as (
  select 
    type, rating,
    count(*),
    rank() over (partition by type order by count(*) desc) as ranking
  from netflix
  group by type, rating
)
select * from top
where ranking = 1;
```

### Q3) List all Movies released in a specific year (e.g., 2020)  
```sql
select
  title, release_year
from netflix
where type = 'Movie'
  and release_year = '2020';
```

### Q4) Find the top 5 countries having most content on Netflix (split if more than one country is in one cell)  
```sql
select 
  unnest(string_to_array(country, ',')) as new_country,
  count(show_id) as total_count
from netflix
group by 1
order by 2 desc
limit 5;
```

### Q5) Identify the longest Movie  
```sql
select *
from netflix
where type = 'Movie'
  and duration = (select max(duration) from netflix);
```

### Q6) Find the content added in the last 5 years  
```sql
select *
from netflix
where to_date(date_added, 'Month DD, YYYY') >= current_date - interval '5 years';
```

### Q7) Find all the Movies/TV Shows directed by 'Rajiv Chilaka'  
```sql
select *
from netflix
where director ilike '%Rajiv Chilaka%';
```

### Q8) List all the TV Shows with more than 5 seasons  
```sql
select *
from netflix
where type = 'TV Show'
  and split_part(duration, ' ', 1)::numeric > 5;
```

### Q9) Count the number of listed items in each genre  
```sql
select
  count(show_id) as total_count,
  unnest(string_to_array(listed_in, ',')) as genre
from netflix
group by 2
order by 1 desc;
```

### Q10) Find each year number of content released by India on Netflix and order top 5 years with highest avg content release  
```sql
select
  extract(year from to_date(date_added,'Month DD,YYYY')) as year,
  count(*),
  round(
    count(*)::numeric / (select count(*) from netflix where country = 'India')::numeric * 100
  , 2) as avg_content
from netflix 
where country = 'India'
group by year
order by avg_content desc
limit 5;
```

### Q11) List all the Movies that are Documentaries  
```sql
select * from netflix
where listed_in ilike '%Documentaries%';
```

### Q12) Find all Movies Salman Khan appeared in last 10 years  
```sql
select * from netflix
where casts ilike '%Salman Khan%'
  and release_year::numeric > extract(year from current_date) - 10;
```

### Q13) Find top 10 characters who have appeared in the highest number of Movies in India  
```sql
select
  unnest(string_to_array(casts, ',')) as characters,
  count(casts) as total_character
from netflix
group by 1
order by 2 desc
limit 10;
```

### Q14) Categorize the content based on keywords 'kills' and 'violence' in description  
```sql
with new_table as (
  select *,
    case
      when description ilike '%kills%' 
        or description ilike '%violence%' then 'Bad_content'
      else 'Good_content'
    end as category
  from netflix
)
select
  category,
  count(category) as total
from new_table
group by 1;
