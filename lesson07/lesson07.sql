-- ��������� ������ ������������� users, ������� ����������� ���� �� ���� ����� orders � �������� ��������.
SELECT DISTINCT 
	o.user_id, 
	u.name 
FROM orders o 
JOIN users u ON o.user_id = u.id;

-- �������� ������ ������� products � �������� catalogs, ������� ������������� ������.
SELECT 
	p.id, 
	p.name AS product_name, 
	catalog_id, 
	c.name AS catalog_name  
FROM products p 
JOIN catalogs c ON p.catalog_id = c.id;


-- ����� ������� ������� ������ flights (id, from, to) � ������� ������� cities (label, name). 
-- ���� from, to � label �������� ���������� �������� �������, ���� name � �������. 
-- �������� ������ ������ flights � �������� ���������� �������.

-- ������ �������.
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
	('moscow', '������'),
	('omsk', '����'),
	('kazan', '������'),
	('irkutsk', '�������'),
	('novgorod', '��������');

SELECT 
	f.id, 
	c.name, 
	c1.name 
FROM flights f 
LEFT JOIN cities c ON from_city = c.label 
LEFT JOIN cities c1 ON to_city = c1.label 
ORDER BY id;