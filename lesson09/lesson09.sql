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


-- Пусть имеется таблица с календарным полем created_at. В ней размещены разряженые календарные записи за август 2018 года '2018-08-01', '2016-08-04', 
-- '2018-08-16' и 2018-08-17. Составьте запрос, который выводит полный список дат за август, выставляя в соседнем поле значение 1, если дата присутствует
-- в исходном таблице и 0, если она отсутствует.



-- Пусть имеется любая таблица с календарным полем created_at. Создайте запрос, который удаляет устаревшие записи из таблицы, оставляя только 5 самых свежих записей.
DELETE FROM some_table WHERE created_at NOT IN
(SELECT created_at FROM some_table ORDER BY created_at DESC LIMIT 5)


-- Создайте двух пользователей которые имеют доступ к базе данных shop. Первому пользователю shop_read должны быть доступны только запросы на чтение данных,
-- второму пользователю shop — любые операции в пределах базы данных shop.
GRANT SELECT ON *.* TO 'shop_read'@'localhost' IDENTIFIED WITH sha256_password BY 'pass1';
GRANT ALL ON *.* TO 'shop'@'localhost' IDENTIFIED WITH sha256_password BY 'pass2';


-- Пусть имеется таблица accounts содержащая три столбца id, name, password, содержащие первичный ключ, имя пользователя и его пароль. Создайте представление
-- username таблицы accounts, предоставляющий доступ к столбцам id и name. Создайте пользователя user_read, который бы не имел доступа к таблице accounts,
-- однако, мог бы извлекать записи из представления username.
CREATE VIEW view2 AS SELECT d, name, FROM accounts;
GRANT SELECT ON *.view2 TO 'user_read'@'localhost' IDENTIFIED WITH sha256_password BY 'pass1';


-- Создайте хранимую функцию hello(), которая будет возвращать приветствие, в зависимости от текущего времени суток. 
-- С 6:00 до 12:00 функция должна возвращать фразу "Доброе утро", с 12:00 до 18:00 функция должна возвращать фразу "Добрый день",
-- с 18:00 до 00:00 — "Добрый вечер", с 00:00 до 6:00 — "Доброй ночи".

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



-- В таблице products есть два текстовых поля: name с названием товара и description с его описанием.
-- Допустимо присутствие обоих полей или одно из них. Ситуация, когда оба поля принимают неопределенное значение NULL неприемлема.
-- Используя триггеры, добейтесь того, чтобы одно из этих полей или оба поля были заполнены. При попытке присвоить полям NULL-значение
-- необходимо отменить операцию.
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


-- Напишите хранимую функцию для вычисления произвольного числа Фибоначчи. Числами Фибоначчи называется последовательность в которой
-- число равно сумме двух предыдущих чисел. Вызов функции FIBONACCI(10) должен возвращать число 55.


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









