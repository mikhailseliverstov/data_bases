-- Составьте список пользователей users, которые осуществили хотя бы один заказ orders в интернет магазине.
SELECT DISTINCT 
	o.user_id, 
	u.name 
FROM orders o 
JOIN users u ON o.user_id = u.id;

-- Выведите список товаров products и разделов catalogs, который соответствует товару.
SELECT 
	p.id, 
	p.name AS product_name, 
	catalog_id, 
	c.name AS catalog_name  
FROM products p 
JOIN catalogs c ON p.catalog_id = c.id;


-- Пусть имеется таблица рейсов flights (id, from, to) и таблица городов cities (label, name). 
-- Поля from, to и label содержат английские названия городов, поле name — русское. 
-- Выведите список рейсов flights с русскими названиями городов.

-- Создаём таблицы.
DROP TABLE IF EXISTS flights;
CREATE TABLE flights (
  id SERIAL PRIMARY KEY,
  from_city VARCHAR(255),
  to_city VARCHAR(255)
);
	 
INSERT INTO flights (from_city, to_city) VALUES
	('moscow', 'omsk'),
	('novgorod', 'kazan'),
	('irkutsk', 'moscow'),
	('omsk', 'irkutsk'),
	('moscow', 'kazan');

DROP TABLE IF EXISTS cities;
CREATE TABLE cities (
	label VARCHAR(255),
	name VARCHAR(255)
);
	
INSERT INTO cities (label, name) VALUES
	('moscow', 'Москва'),
	('omsk', 'Омск'),
	('kazan', 'Казань'),
	('irkutsk', 'Иркутск'),
	('novgorod', 'Новгород');

SELECT 
	f.id, 
	c.name, 
	c1.name 
FROM flights f 
LEFT JOIN cities c ON from_city = c.label 
LEFT JOIN cities c1 ON to_city = c1.label 
ORDER BY id;