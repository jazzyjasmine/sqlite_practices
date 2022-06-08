-- Trigger 1
-- After changing the apartment_id of the apartment table, 
-- the apartment_id of other tables who has apartment_id as
-- foreign key should also be changed.

CREATE TRIGGER IF NOT EXISTS update_apartment_id_trigger
AFTER UPDATE ON apartment 
WHEN OLD.apartment_id != NEW.apartment_id
BEGIN
UPDATE user_apartment_wishlist 
SET apartment_id = NEW.apartment_id
WHERE apartment_id = OLD.apartment_id;
UPDATE floor_plan  
SET apartment_id = NEW.apartment_id
WHERE apartment_id = OLD.apartment_id;
UPDATE floor_plan_price
SET apartment_id = NEW.apartment_id
WHERE apartment_id = OLD.apartment_id;
END;

-- Trigger 2
-- Update park_log after INSERT/UPDATE/DELETE modification to the park table
CREATE TRIGGER IF NOT EXISTS update_park_name_trigger
AFTER UPDATE ON park
WHEN OLD.park_name != NEW.park_name
BEGIN
INSERT INTO update_park_name_log VALUES(DATETIME(), OLD.park_name, NEW.park_name);
END;

-- Trigger 3
-- Before inserting record to user table, check if the email_address is valid.
CREATE TRIGGER IF NOT EXISTS insert_user_trigger
BEFORE INSERT ON user
BEGIN
SELECT
CASE WHEN NEW.email_address NOT LIKE '%_@__%.__%' THEN RAISE (ABORT,'Invalid email address. Should be in format ***@***.***.') END;
END;
