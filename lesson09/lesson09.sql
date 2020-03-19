-- В базе данных shop и sample присутствуют одни и те же таблицы, учебной базы данных. 
-- Переместите запись id = 1 из таблицы shop.users в таблицу sample.users. Используйте транзакции.

-- Начинаем транзакцию
START TRANSACTION;

-- проверяем наличие данных с id = 1 в таблице users БД shop
SELECT id, name FROM shop.users WHERE id = 1;

-- копируем данные в таблицу sample.users
INSERT INTO sample.users (id, name)  (
	SELECT id, name FROM shop.users WHERE id = 1);
	
-- удаляем строку из таблицы shop.users
DELETE FROM shop.users WHERE id = 1;

-- проверяем изменения
SELECT * FROM sample.users;
SELECT * FROM shop.users;

-- применяем изменения к данным
COMMIT;


-- Создайте представление, которое выводит название name товарной позиции из таблицы products и соответствующее название каталога name из таблицы catalogs.
USE shop;
CREATE VIEW view1 AS SELECT p.name, c.name AS cat_name FROM shop.products p
LEFT JOIN shop.catalogs c ON p.catalog_id = c.id;




