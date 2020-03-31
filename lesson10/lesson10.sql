USE vk;

-- 1. Проанализировать какие запросы могут выполняться наиболее часто в процессе работы приложения и добавить необходимые индексы.

CREATE UNIQUE INDEX users_email_idx ON users(email); -- насколько я понял, сортировка при создании индекса создаётся автоматически
CREATE UNIQUE INDEX users_first_name_last_name_idx ON users(first_name,last_name); -- индекс пригодится при поиске пользователя в интерфейсе VK
CREATE INDEX profiles_birthday_idx ON profiles(birthday); -- поможет делать выборки по датам

-- 2. Задание на оконные функции

SELECT
	c.name, -- имя группы
	COUNT(cu.user_id) OVER() / MAX(c.id) OVER() AS avg_users, -- среднее количество пользователей в группах
	MAX(p.birthday) OVER w AS youngest_user, -- самый молодой пользователь в группе
	MIN(p.birthday) OVER w AS oldest_user, -- самый пожилой пользователь в группе
	COUNT(cu.user_id) OVER w AS cnt_users,-- количество пользователей в группе
	COUNT(p.user_id) OVER() AS total_users,-- всего пользователей в системе
	((COUNT(cu.user_id) OVER w) / (COUNT(p.user_id) OVER())) * 100 AS '%%'-- отношение в процентах (количество пользователей в группе / всего пользователей в системе) * 100
FROM communities_users cu
LEFT JOIN communities c ON cu.community_id = c.id 
LEFT JOIN profiles p ON cu.user_id = p.user_id 
	WINDOW w AS (PARTITION BY cu.community_id);  

SELECT community_id, COUNT(user_id) FROM communities_users cu GROUP BY community_id ;
SELECT COUNT(id) FROM users;
SELECT * FROM communities;

-- 3. Разобраться как построен и работает следующий запрос:
-- Найти 10 пользователей, которые проявляют наименьшую активность в использовании социальной сети.

SELECT users.id,
	COUNT(DISTINCT messages.id) + COUNT(DISTINCT likes.id) + COUNT(DISTINCT media.id) AS activity
FROM users
LEFT JOIN messages ON users.id = messages.from_user_id
LEFT JOIN likes	ON users.id = likes.user_id
LEFT JOIN media	ON users.id = media.user_id
GROUP BY users.id
ORDER BY activity
LIMIT 10;

-- моё предложение по оптимизации данного запроса - использование вложенных запросов избавляет от необходимости трёх JOIN'ов
-- и дальнейшей обработки (группировки, схлопывания) полученной "раздутой" таблицы. Скорость выполнения запроса в три раза ниже, чем у исходного.

SELECT 
	id,
	(SELECT COUNT(id) FROM messages m WHERE u.id = m.from_user_id) +
	(SELECT COUNT(id) FROM likes l WHERE u.id = l.user_id) +
	(SELECT COUNT(id) FROM media md WHERE u.id = md.user_id) AS activity
FROM users u
ORDER BY activity ASC
LIMIT 10;

-- Предложения по денормализации:
-- 1. вынести из таблицы messages поле body в отдельную таблицу с полями message_id, body. Это ускорит обращения по подсчёту сообщений на юзера.
-- 2. объединить таблицы likes и target_types
-- 3. объединить таблицы media и media_types
