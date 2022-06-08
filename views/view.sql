-- View 1: Apartments that provide long lease
-- This view is a simple entrance (simplying-query) for people looking for apartments 
-- with a relatively long leasing period (>=12 months). This view also mapped variables with
-- enumeration types (e.g. laundry_type, parking_type) into the corresponding text for easier 
-- understanding.
create view if not exists long_lease_apartment as
select
apartment_name,
case when laundry_type = 1 then 'onsite laundry' else 'in-unit laundry' end as laundry_type_str,
case when parking_type = 1 then 'street parking'
	 when parking_type = 2 then 'city-run parking lot'
     when parking_type = 3 then 'apartment-run parking lot'
     end as parking_type_str,
landlord_name,
landlord_rating,
landlord_rating_count,
official_website,
address,
city,
zipcode
from apartment
left join floor_plan on apartment.apartment_id = floor_plan.apartment_id
left join floor_plan_price on floor_plan.apartment_id = floor_plan_price.apartment_id and floor_plan.floor_plan_id = floor_plan_price.floor_plan_id
left join price_plan on floor_plan_price.price_plan_id = price_plan.price_plan_id
left join landlord on apartment.landlord_id = landlord.landlord_id
where leasing_period >= 12
group by
apartment_name
order by landlord_rating desc;


-- View 2: Price range for each floor plan in a long lease
-- This view is a simple entrance (simplying-query) for people concerning about the
-- highest possible price and lowest possible price for each floor plan in a long lease (>= 12 months).
create view if not exists long_lease_floor_plan_price_range as
select
case when floor_plan_type = 1 then 'studio'
	 when floor_plan_type = 2 then '1b1b'
     when floor_plan_type = 3 then '2b2b'
     when floor_plan_type = 4 then '2b1b'
     when floor_plan_type = 5 then '3b2b'
end as floor_plan_type_str,
max(price) as highest_possible_price,
min(price) as lowest_possible_price
from floor_plan
left join apartment on floor_plan.apartment_id = apartment.apartment_id
left join floor_plan_price on floor_plan.apartment_id = floor_plan_price.apartment_id and floor_plan.floor_plan_id = floor_plan_price.floor_plan_id
left join price_plan on floor_plan_price.price_plan_id = price_plan.price_plan_id
where leasing_period >= 12
group by 
case when floor_plan_type = 1 then 'studio'
	 when floor_plan_type = 2 then '1b1b'
     when floor_plan_type = 3 then '2b2b'
     when floor_plan_type = 4 then '2b1b'
     when floor_plan_type = 5 then '3b2b'
end;


-- View 3: Rank apartments by popularity
-- This view is a simple entrance (simplying-query) for people concerning about the
-- popularity of apartments. The popularity of an apartment is defined as the times
-- it is added into a user's wishlist. Apartments that have never appeared in a wishlist
-- are not shown in this view.
create view if not exists apartment_popularity as
select
user_apartment_wishlist.apartment_id as apartment_id,
apartment_name,
case when laundry_type = 1 then 'onsite laundry' else 'in-unit laundry' end as laundry_type_str,
case when parking_type = 1 then 'street parking'
	 when parking_type = 2 then 'city-run parking lot'
     when parking_type = 3 then 'apartment-run parking lot'
     end as parking_type_str,
official_website,
address,
city,
zipcode,
count(*) as show_times
from user_apartment_wishlist
left join apartment on user_apartment_wishlist.apartment_id = apartment.apartment_id
group by 
user_apartment_wishlist.apartment_id,
apartment_name,
case when laundry_type = 1 then 'onsite laundry' else 'in-unit laundry' end,
case when parking_type = 1 then 'street parking'
	 when parking_type = 2 then 'city-run parking lot'
     when parking_type = 3 then 'apartment-run parking lot'
     end,
official_website,
address,
city,
zipcode
order by 
count(*) desc;
