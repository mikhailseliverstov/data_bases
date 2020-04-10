USE shop;

-- Создайте таблицу logs типа Archive. Пусть при каждом создании записи в таблицах users, 
-- catalogs и products в таблицу logs помещается время и дата создания записи, название таблицы, 
-- идентификатор первичного ключа и содержимое поля name.

DROP TABLE IF EXISTS logs;
CREATE TABLE logs (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	table_name VARCHAR(50),
	id INT UNSIGNED NOT NULL
	name VARCHAR(50)
) COMMENT = 'Таблица логов изменений' ENGINE=Archive;

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

-- Создайте SQL-запрос, который помещает в таблицу users миллион записей.


-- В базе данных Redis подберите коллекцию для подсчета посещений с определенных IP-адресов.
HSET ip 192.168.1.0 1


-- При помощи базы данных Redis решите задачу поиска имени пользователя по электронному адресу и наоборот, поиск электронного адреса пользователя по его имени.
SET name name@mail.ru
SET name@mail.ru name
GET name
GET name@mail.ru


-- Организуйте хранение категорий и товарных позиций учебной базы данных shop в СУБД MongoDB.
db.shop.insert({category: 'Процессоры'})
db.shop.insert({category: 'Материнские платы'})
db.shop.insert({category: 'Видеокарты'})
db.shop.insert({category: 'Жесткие диски'})
db.shop.insert({category: 'Оперативная память'})

db.shop.update({category: 'Процессоры'}, {$set: { products:['Intel Core i3-8100', 'Intel Core i5-7400', 'AMD FX-8320E', 'AMD FX-8320'] }})
db.shop.update({category: 'Материнские платы'}, {$set: { products:['ASUS ROG MAXIMUS X HERO', 'Gigabyte H310M S2H', 'MSI B250M GAMING PRO'] }})


