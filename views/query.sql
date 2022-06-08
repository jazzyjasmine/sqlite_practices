-- Query 1
-- For apartment with long lease, list those apartments under 
-- corresponding landlords (note that we only interested in 
-- theses landlord: Mac Properties, TLC Management and AIR Communities), 
-- in the following format:

-- Mac Properties | TLC Management | AIR Communities
-- Apartment A    | Apartment B    | Apartment C
-- Apartment B

-- Used:
-- 1) aggregation function with GROUP BY 
-- 2) view "long_lease_apartment"
-- 3) CASE statement

select
max(case when landlord_name = 'Mac Properties' then apartment_name end) as `Mac Properties`,
max(case when landlord_name = 'TLC Management' then apartment_name end) as `TLC Management`,
max(case when landlord_name = 'AIR Communities' then apartment_name end) as `AIR Communities`
from (
    select
    apartment_name,
    landlord_name,
    row_number() over(partition by landlord_name order by apartment_name) as row_id
    from long_lease_apartment
) view_data
group by row_id;


-- Query 2
-- list the apartment name(s) who have the lowest price
-- for studio in a long lease

-- Used: 
-- 1) NATURAL JOIN
-- 2) view "long_lease_floor_plan_price_range"

select
distinct apartment_name
from apartment
natural join floor_plan
natural join floor_plan_price
natural join price_plan
where floor_plan_type = 1 and leasing_period >= 12 and price = (
  select
  lowest_possible_price
  from long_lease_floor_plan_price_range
  where floor_plan_type_str = 'studio'
);


-- Query 3
-- From the top ten popular apartments, get the apartment id and apartment name who has more
-- than one floor plan for 2b2b, return the results ordered by popularity descendingly.
-- Note that popularity is defined as the show times on the wishlist.

-- Used:
-- 1) aggregation function with GROUP BY and HAVING
-- 2) view "apartment_popularity"
-- 3) JOIN with USING
-- 4) temporary table

create temp table if not exists top_ten_popular_apartments as
select
apartment_id,
apartment_name,
show_times
from apartment_popularity
limit 10;

select
top_ten_popular_apartments.apartment_id as apartment_id,
apartment_name
from top_ten_popular_apartments 
left join floor_plan using (apartment_id)
where floor_plan_type = 3
group by 
top_ten_popular_apartments.apartment_id,
apartment_name
having count(*) > 1
order by show_times desc;


-- Query 4
-- For each plaza, get the number of restaurants associated with it.

-- Used:
-- 1) JOIN with ON

select
plaza.plaza_name as plaza_name,
count(restaurant.restaurant_name) as restaurant_count
from plaza
left join restaurant on plaza.plaza_name = restaurant.plaza_name
group by plaza.plaza_name;


-- Query 5
-- Find the median of all landloard rating.

select 
avg(landlord_rating) as median
from (
    select 
    landlord_rating
    from landlord
    order by landlord_rating
    limit 2 - (select count(*) from landlord) % 2
    offset (select (count(*) - 1) / 2 from landlord)
) tmp;


-- Query 6
-- For each landlord, find the number of apartments it owns, order
-- the results by apartment count descendingly.

select
landlord.landlord_id as landlord_id,
landlord_name,
count(apartment_id) as apartment_count
from landlord 
left join apartment on landlord.landlord_id = apartment.landlord_id
group by landlord.landlord_id, landlord_name
order by count(apartment_id) desc;