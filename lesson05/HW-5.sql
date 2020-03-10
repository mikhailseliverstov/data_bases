USE vk;

--����� � ������� users ���� created_at � updated_at ��������� ��������������. ��������� �� �������� ����� � ��������.
UPDATE users
SET created_at = CURRENT_TIMESTAMP, updated_at = CURRENT_TIMESTAMP;

--������� users ���� �������� ��������������. ������ created_at � updated_at ���� ������ ����� VARCHAR � � ��� ������ 
--����� ���������� �������� � ������� "20.10.2017 8:10". ���������� ������������� ���� � ���� DATETIME, �������� �������� ����� ��������.
ALTER TABLE users
MODIFY COLUMN created_at DATETIME,
MODIFY COLUMN updated_at DATETIME;

--� ������� ��������� ������� storehouses_products � ���� value ����� ����������� ����� ������ �����: 0, ���� ����� ���������� � ���� ����, 
--���� �� ������ ������� ������. ���������� ������������� ������ ����� �������, ����� ��� ���������� � ������� ���������� �������� value. 
--������, ������� ������ ������ ���������� � �����, ����� ���� �������.
SELECT * FROM table
ORDER BY
	CASE WHEN value = '0'
		THEN = 1
		ELSE = 0
	END;

--�� ������� users ���������� ������� �������������, ���������� � ������� � ���. ������ ������ � ���� ������ ���������� �������� ('may', 'august')
SELECT * FROM users
WHERE month IN ('may', 'august')


--�� ������� catalogs ����������� ������ ��� ������ �������. SELECT * FROM catalogs WHERE id IN (5, 1, 2); ������������ ������ � �������, �������� � ������ IN.
SELECT * FROM catalogs 
WHERE id IN (5, 1, 2)
ORDER BY CASE id
         WHEN '5' THEN 1
         WHEN '1' THEN 2
	 WHEN '2' THEN 3
         END;

--����������� ������� ������� ������������� � ������� users
SELECT ROUND(AVG(DATEDIFF(CURRENT_DATE, birthday)/365.25),0) FROM profiles;

--����������� ���������� ���� ��������, ������� ���������� �� ������ �� ���� ������. ������� ������, ��� ���������� ��� ������ �������� ����, � �� ���� ��������.
SELECT WEEKDAY(CONCAT('2020', SUBSTR(birthday,5))) AS day, COUNT(WEEKDAY(CONCAT('2020', SUBSTR(birthday,5)))) FROM profiles GROUP BY day ORDER BY day ASC;
