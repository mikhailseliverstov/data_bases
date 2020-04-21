SHOW tables;

SELECT * FROM customers;

UPDATE customers SET updated_at = CURRENT_TIMESTAMP WHERE created_at > updated_at;



SELECT * FROM profiles;

UPDATE profiles SET updated_at = CURRENT_TIMESTAMP WHERE created_at > updated_at;

UPDATE profiles SET birthday = DATE_SUB(CONVERT(created_at, DATE), INTERVAL 18 YEAR) WHERE CONVERT(created_at, DATE) < birthday;

CREATE TEMPORARY TABLE gender (gender CHAR(1));

INSERT INTO gender VALUES ('m'), ('f');

UPDATE profiles SET gender = (SELECT gender FROM gender ORDER BY RAND() LIMIT 1);



SELECT * FROM customers;

UPDATE customers SET updated_at = CURRENT_TIMESTAMP WHERE created_at > updated_at;



SELECT * FROM orders;

UPDATE orders SET updated_at = CURRENT_TIMESTAMP WHERE created_at > updated_at;

UPDATE orders SET promo = NULL ORDER BY RAND() LIMIT 800;

UPDATE orders SET customer_id = ROUND((RAND() * (500 - 1)) + 1);



SELECT * FROM routes;

ALTER TABLE routes
	DROP CONSTRAINT `routes_from_city_id_fk`;

ALTER TABLE routes
	DROP CONSTRAINT `routes_to_city_id_fk`;

UPDATE routes SET 
	from_city_id = FLOOR(RAND() * 200),
	to_city_id = FLOOR(RAND() * 200);

UPDATE routes SET
	from_city_id = FLOOR(RAND() * 200) WHERE from_city_id = 0;

UPDATE routes SET
	to_city_id = FLOOR(RAND() * 200) WHERE to_city_id = 0;

ALTER TABLE routes
	ADD CONSTRAINT routes_from_city_id_fk 
		FOREIGN KEY (from_city_id) REFERENCES cities(id)
		ON DELETE SET NULL;
	
ALTER TABLE routes
	ADD CONSTRAINT routes_to_city_id_fk 
		FOREIGN KEY (to_city_id) REFERENCES cities(id)
		ON DELETE SET NULL;
	
	
	
SELECT * FROM transactions;

UPDATE transactions SET created_at = CONCAT(ROUND((RAND() * (2019 - 2016)) + 2016), SUBSTR(created_at, 5)) WHERE created_at < '2016-01-01';

UPDATE transactions SET updated_at = CURRENT_TIMESTAMP WHERE created_at > updated_at;

UPDATE transactions SET utm_source = REPLACE(utm_source, '"', '');

UPDATE transactions SET utm_medium = REPLACE(utm_medium, '"', '');

UPDATE transactions SET utm_campaign = NULL WHERE utm_medium = 'organic';

UPDATE transactions SET utm_term = NULL WHERE utm_medium = 'organic';

UPDATE transactions SET id = ROUND((RAND() * (9999999 - 1000000)) + 1000000);

ALTER TABLE orders
	DROP CONSTRAINT orders_transaction_id_fk;

UPDATE orders SET transaction_id = (SELECT id FROM
	(SELECT 
		ROW_NUMBER() OVER() AS rnum,
		id
	FROM transactions) tbl WHERE orders.id = tbl.rnum);

ALTER TABLE orders 
	ADD CONSTRAINT orders_transaction_id_fk
		FOREIGN KEY (transaction_id) REFERENCES transactions(id);
	

	
SELECT * FROM bookings;
	
UPDATE bookings SET state = REPLACE(state, '"', '');
UPDATE bookings SET from_city_id = (SELECT id FROM cities ORDER BY RAND() LIMIT 1);
UPDATE bookings SET to_city_id = (SELECT id FROM cities ORDER BY RAND() LIMIT 1);
UPDATE bookings SET route_id = (SELECT id FROM routes ORDER BY RAND() LIMIT 1);



SELECT * FROM analytics a ;
	
UPDATE analytics SET
	utm_source = REPLACE(utm_source, '"', ''),
	utm_medium = REPLACE(utm_medium, '"', '');

CREATE TEMPORARY TABLE devices (devices CHAR(10));

INSERT INTO devices VALUES ('desktop'), ('mobile'), ('tablet');

UPDATE analytics SET device_name = (SELECT devices FROM devices ORDER BY RAND() LIMIT 1);

UPDATE analytics SET date = CONCAT(ROUND((RAND() * (2019 - 2016)) + 2016),SUBSTR(date, 5));


UPDATE bookings SET state = TRIM(state);
UPDATE transactions SET
	utm_source = TRIM(utm_source),
	utm_medium = TRIM(utm_medium);