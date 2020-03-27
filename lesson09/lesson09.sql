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


-- ����� ������� ������� � ����������� ����� created_at. � ��� ��������� ���������� ����������� ������ �� ������ 2018 ���� '2018-08-01', '2016-08-04', 
-- '2018-08-16' � 2018-08-17. ��������� ������, ������� ������� ������ ������ ��� �� ������, ��������� � �������� ���� �������� 1, ���� ���� ������������
-- � �������� ������� � 0, ���� ��� �����������.



-- ����� ������� ����� ������� � ����������� ����� created_at. �������� ������, ������� ������� ���������� ������ �� �������, �������� ������ 5 ����� ������ �������.
DELETE FROM some_table WHERE created_at NOT IN
(SELECT created_at FROM some_table ORDER BY created_at DESC LIMIT 5)


-- �������� ���� ������������� ������� ����� ������ � ���� ������ shop. ������� ������������ shop_read ������ ���� �������� ������ ������� �� ������ ������,
-- ������� ������������ shop � ����� �������� � �������� ���� ������ shop.
GRANT SELECT ON *.* TO 'shop_read'@'localhost' IDENTIFIED WITH sha256_password BY 'pass1';
GRANT ALL ON *.* TO 'shop'@'localhost' IDENTIFIED WITH sha256_password BY 'pass2';


-- ����� ������� ������� accounts ���������� ��� ������� id, name, password, ���������� ��������� ����, ��� ������������ � ��� ������. �������� �������������
-- username ������� accounts, ��������������� ������ � �������� id � name. �������� ������������ user_read, ������� �� �� ���� ������� � ������� accounts,
-- ������, ��� �� ��������� ������ �� ������������� username.
CREATE VIEW view2 AS SELECT d, name, FROM accounts;
GRANT SELECT ON *.view2 TO 'user_read'@'localhost' IDENTIFIED WITH sha256_password BY 'pass1';


-- �������� �������� ������� hello(), ������� ����� ���������� �����������, � ����������� �� �������� ������� �����. 
-- � 6:00 �� 12:00 ������� ������ ���������� ����� "������ ����", � 12:00 �� 18:00 ������� ������ ���������� ����� "������ ����",
-- � 18:00 �� 00:00 � "������ �����", � 00:00 �� 6:00 � "������ ����".

DELIMITER //
CREATE FUNCTION hello ()
RETURNS TEXT NOT DETERMINISTIC
BEGIN
	SELECT 
		CASE
			WHEN CURRENT_TIME BETWEEN '6:00:00' AND '12:00:00' THEN 'Good morning'
			WHEN CURRENT_TIME BETWEEN '12:00:00' AND '18:00:00' THEN 'Good day'
			WHEN CURRENT_TIME BETWEEN '18:00:00' AND '00:00:00' THEN 'Good evening'
			WHEN CURRENT_TIME BETWEEN '00:00:00' AND '6:00:00' THEN 'Good night'
		END;
END //



-- � ������� products ���� ��� ��������� ����: name � ��������� ������ � description � ��� ���������.
-- ��������� ����������� ����� ����� ��� ���� �� ���. ��������, ����� ��� ���� ��������� �������������� �������� NULL �����������.
-- ��������� ��������, ��������� ����, ����� ���� �� ���� ����� ��� ��� ���� ���� ���������. ��� ������� ��������� ����� NULL-��������
-- ���������� �������� ��������.
USE shop;
CREATE TRIGGER check_product_fields BEFORE INSERT ON poducts
FOR EACH ROW 
BEGIN 
	DECLARE name1 TINYTEXT DEFAULT 'Name';
	IF NEW.name = NULL AND NEW.description = NULL THEN 
	SET name = name1
	END IF;
END//

CREATE TRIGGER check_product_fields BEFORE UPDATE ON poducts
FOR EACH ROW 
BEGIN 
	IF NEW.name = NULL AND NEW.description = NULL THEN 
		SET NEW.name = OLD.name
		SET NEW.description = OLD.description
	END IF;
END//


-- �������� �������� ������� ��� ���������� ������������� ����� ���������. ������� ��������� ���������� ������������������ � �������
-- ����� ����� ����� ���� ���������� �����. ����� ������� FIBONACCI(10) ������ ���������� ����� 55.


CREATE FUNCTION FIBONACCI (value INT)
RETURNS INT
BEGIN
	SET @x = 1;
	DECLARE @n INT DEFAULT 1;
	DECLARE @n1 INT DEFAULT 0;
	DECLARE @f INT DEFAULT 0;
	WHILE @x < value DO
		SET @f = @n + @n1;
		SET @n1 = @n;
		SET @n = @f;
		SET @x = @x + 1;
	END WHILE;
	RETURN @f;
END//









