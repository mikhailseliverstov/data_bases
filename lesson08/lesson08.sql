USE vk;


/*Задание 2. Подсчитать общее количество лайков, которые получили 10 самых молодых пользователей.*/
SELECT 
	target_id, 
	COUNT(*), 
	birthday 
FROM likes l 
LEFT JOIN users u ON target_id = u.id 
LEFT JOIN profiles p ON u.id = p.user_id 
GROUP BY target_id, birthday 
ORDER BY birthday DESC
LIMIT 10;


/*3. Определить кто больше поставил лайков (всего) - мужчины или женщины?*/
SELECT 
	gender,
	COUNT(*) AS likes_num
FROM profiles p
LEFT JOIN likes l ON p.user_id = l.user_id 
GROUP BY gender;


/*4. Найти 10 пользователей, которые проявляют наименьшую активность в использовании социальной сети.*/
SELECT 
	u.id,
	CONCAT(first_name, ' ', last_name) AS name,
	COUNT(DISTINCT m.id) AS msgs,
	COUNT(DISTINCT p.id) AS psts,
	COUNT(DISTINCT f.friend_id) AS frds,
	COUNT(DISTINCT community_id) AS grps,
	COUNT(DISTINCT l.id) AS lks
FROM users u 
LEFT JOIN messages m ON u.id = m.from_user_id 
LEFT JOIN posts p ON u.id = p.user_id 
LEFT JOIN friendship f ON u.id = f.user_id 
LEFT JOIN communities_users c ON u.id = c.user_id 
LEFT JOIN likes l ON u.id = l.user_id 
GROUP BY u.id
ORDER BY msgs + psts + frds + grps + lks ASC;


