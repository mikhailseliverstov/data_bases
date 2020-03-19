-- � ���� ������ shop � sample ������������ ���� � �� �� �������, ������� ���� ������. 
-- ����������� ������ id = 1 �� ������� shop.users � ������� sample.users. ����������� ����������.

-- �������� ����������
START TRANSACTION;

-- ��������� ������� ������ � id = 1 � ������� users �� shop
SELECT id, name FROM shop.users WHERE id = 1;

-- �������� ������ � ������� sample.users
INSERT INTO sample.users (id, name)  (
	SELECT id, name FROM shop.users WHERE id = 1);
	
-- ������� ������ �� ������� shop.users
DELETE FROM shop.users WHERE id = 1;

-- ��������� ���������
SELECT * FROM sample.users;
SELECT * FROM shop.users;

-- ��������� ��������� � ������
COMMIT;


-- �������� �������������, ������� ������� �������� name �������� ������� �� ������� products � ��������������� �������� �������� name �� ������� catalogs.
USE shop;
CREATE VIEW view1 AS SELECT p.name, c.name AS cat_name FROM shop.products p
LEFT JOIN shop.catalogs c ON p.catalog_id = c.id;




