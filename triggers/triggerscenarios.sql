-- Modification 1-1 
-- This modification triggers Trigger 1 by changing the apartment_id.
-- Expected outcome: The modification itself causes the apartment with id 20
-- changes its id to 21 in the apartment table. Then the Trigger 1 is triggered
-- and thus causes all records with apartment id equals 20 change their apartment
-- id to 21 in user_apartment_wishlist table, floor_plan table and floor_plan_price table.
update apartment
set apartment_id = 21
where apartment_id = 20;

-- Query to show the results of Modification 1-1
-- After executing the Modification 1-1, all records with apartment_id = 20 should 
-- have their apartment_id equals to 21.
-- Expected outcome before executing Modification 1-1: 6|0|1|0|1|0
-- Expected outcome after executing Modification 1-1: 0|6|0|1|0|1
select
(select count(*) from user_apartment_wishlist where apartment_id = 20) as wishlist_count_apartment_id_20,
(select count(*) from user_apartment_wishlist where apartment_id = 21) as wishlist_count_apartment_id_21,
(select count(*) from floor_plan where apartment_id = 20) as floor_plan_count_apartment_id_20,
(select count(*) from floor_plan where apartment_id = 21) as floor_plan_count_apartment_id_21,
(select count(*) from floor_plan_price where apartment_id = 20) as floor_plan_price_count_apartment_id_20,
(select count(*) from floor_plan_price where apartment_id = 21) as floor_plan_price_count_apartment_id_21;

-- Modification 1-2
-- This modification does not trigger Trigger 1 since it does not change
-- apartment_id.
-- Expected outcome: The record with apartment_id equals to 19 changes its
-- laundry_type to 2.
update apartment 
set laundry_type = 2
where apartment_id = 19;

-- Query to show the results of Modification 1-2
-- Expected outcome before executing Modification 1-2: 4|74|1|55|1|111
-- Expected outcome after executing Modification 1-2: 4|74|1|55|1|111
select
(select count(*) from user_apartment_wishlist where apartment_id = 19) as wishlist_count_apartment_id_19,
(select count(*) from user_apartment_wishlist where apartment_id != 19) as wishlist_count_apartment_id_not_19,
(select count(*) from floor_plan where apartment_id = 19) as floor_plan_count_apartment_id_19,
(select count(*) from floor_plan where apartment_id != 19) as floor_plan_count_apartment_id_not_19,
(select count(*) from floor_plan_price where apartment_id = 19) as floor_plan_price_count_apartment_id_19,
(select count(*) from floor_plan_price where apartment_id != 19) as floor_plan_price_count_apartment_id_not_19;


-- Modification 2-1
-- Update park table and trigger Trigger 2
-- Expected outcome: The park name is changed from "Nichols (John Fountain) Park" to "Nichols Park"
update park
set park_name = 'Nichols Park'
where park_name = 'Nichols (John Fountain) Park';

-- Query to show the results of Modification 2-1
-- Expected outcome: <timestamp of the update operation>|Nichols (John Fountain) Park|Nichols Park
select * from update_park_name_log where old_park_name = 'Nichols (John Fountain) Park';

-- Modification 2-2
-- Update park table without triggering Trigger 2
-- Expected outcome: The address of Elm Park is changed from '5215 S Woodlawn Ave' to '5215 S Woodlawn Avenue'
update park
set address = '5215 S Woodlawn Avenue'
where park_name = 'Elm Park';

-- Query to show the results of Modification 2-2
-- Expected outcome: 0
select count(*) from update_park_name_log where old_park_name = 'Elm Park';


-- Modification 3-1
-- Insert into user table and triggers Trigger 3
-- This modification will triggers an error: "Error: Invalid email address. Should be in format ***@***.***."
insert into user values('invalid_email_address', '123password', 'Walgreens', 20);

-- Query to show the results of Modification 3-1
-- Expected outcome: 0
select count(*) from user where email_address = 'invalid_email_address';

-- Modification 3-2
-- Insert into user table withouting triggering Trigger 3
-- Expected outcome: A new record with email_address = 'fakename@uchicago.edu' is inserted into user table.
insert into user values('fakename@uchicago.edu', '123password', 'UChicago Medicine', 25);

-- Query to show the results of Modification 3-2
-- Expected outcome: fakename@uchicago.edu|123password|UChicago Medicine|25
select * from user where email_address = 'fakename@uchicago.edu';