USE shop;

-- �������� ������� logs ���� Archive. ����� ��� ������ �������� ������ � �������� users, 
-- catalogs � products � ������� logs ���������� ����� � ���� �������� ������, �������� �������, 
-- ������������� ���������� ����� � ���������� ���� name.

DROP TABLE IF EXISTS logs;
CREATE TABLE logs (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	table_name VARCHAR(50),
	id INT UNSIGNED NOT NULL
	name VARCHAR(50)
) COMMENT = '������� ����� ���������' ENGINE=Archive;

DELIMITER -
CREATE TRIGGER logging_changes_users AFTER INSERT ON users
FOR EACH ROW
BEGIN 
	INSERT INTO users VALUES(NULL, NOW(), 'users', NEW.id, NEW.name);
END-

CREATE TRIGGER logging_changes_products AFTER INSERT ON products
FOR EACH ROW
BEGIN 
	INSERT INTO users VALUES(NULL, NOW(), 'products', NEW.id, NEW.name);
END-

CREATE TRIGGER logging_changes_catalogs AFTER INSERT ON catalogs
FOR EACH ROW
BEGIN 
	INSERT INTO users VALUES(NULL, NOW(), 'catalogs', NEW.id, NEW.name);
END-
DELIMITER ;

-- �������� SQL-������, ������� �������� � ������� users ������� �������.


-- � ���� ������ Redis ��������� ��������� ��� �������� ��������� � ������������ IP-�������.
HSET ip 192.168.1.0 1


-- ��� ������ ���� ������ Redis ������ ������ ������ ����� ������������ �� ������������ ������ � ��������, ����� ������������ ������ ������������ �� ��� �����.
SET name name@mail.ru
SET name@mail.ru name
GET name
GET name@mail.ru


-- ����������� �������� ��������� � �������� ������� ������� ���� ������ shop � ���� MongoDB.
db.shop.insert({category: '����������'})
db.shop.insert({category: '����������� �����'})
db.shop.insert({category: '����������'})
db.shop.insert({category: '������� �����'})
db.shop.insert({category: '����������� ������'})

db.shop.update({category: '����������'}, {$set: { products:['Intel Core i3-8100', 'Intel Core i5-7400', 'AMD FX-8320E', 'AMD FX-8320'] }})
db.shop.update({category: '����������� �����'}, {$set: { products:['ASUS ROG MAXIMUS X HERO', 'Gigabyte H310M S2H', 'MSI B250M GAMING PRO'] }})


