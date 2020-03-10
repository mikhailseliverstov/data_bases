USE vk;

--ѕусть в таблице users пол€ created_at и updated_at оказались незаполненными. «аполните их текущими датой и временем.
UPDATE users
SET created_at = CURRENT_TIMESTAMP, updated_at = CURRENT_TIMESTAMP;

--“аблица users была неудачно спроектирована. «аписи created_at и updated_at были заданы типом VARCHAR и в них долгое 
--врем€ помещались значени€ в формате "20.10.2017 8:10". Ќеобходимо преобразовать пол€ к типу DATETIME, сохранив введеные ранее значени€.
ALTER TABLE users
MODIFY COLUMN created_at DATETIME,
MODIFY COLUMN updated_at DATETIME;

--¬ таблице складских запасов storehouses_products в поле value могут встречатьс€ самые разные цифры: 0, если товар закончилс€ и выше нул€, 
--если на складе имеютс€ запасы. Ќеобходимо отсортировать записи таким образом, чтобы они выводились в пор€дке увеличени€ значени€ value. 
--ќднако, нулевые запасы должны выводитьс€ в конце, после всех записей.
SELECT * FROM table
ORDER BY
	CASE WHEN value = '0'
		THEN = 1
		ELSE = 0
	END;

--»з таблицы users необходимо извлечь пользователей, родившихс€ в августе и мае. ћес€цы заданы в виде списка английских названий ('may', 'august')
SELECT * FROM users
WHERE month IN ('may', 'august')


--»з таблицы catalogs извлекаютс€ записи при помощи запроса. SELECT * FROM catalogs WHERE id IN (5, 1, 2); ќтсортируйте записи в пор€дке, заданном в списке IN.
SELECT * FROM catalogs 
WHERE id IN (5, 1, 2)
ORDER BY CASE id
         WHEN '5' THEN 1
         WHEN '1' THEN 2
	 WHEN '2' THEN 3
         END;

--ѕодсчитайте средний возраст пользователей в таблице users
SELECT ROUND(AVG(DATEDIFF(CURRENT_DATE, birthday)/365.25),0) FROM profiles;

--ѕодсчитайте количество дней рождени€, которые приход€тс€ на каждый из дней недели. —ледует учесть, что необходимы дни недели текущего года, а не года рождени€.
SELECT WEEKDAY(CONCAT('2020', SUBSTR(birthday,5))) AS day, COUNT(WEEKDAY(CONCAT('2020', SUBSTR(birthday,5)))) FROM profiles GROUP BY day ORDER BY day ASC;
