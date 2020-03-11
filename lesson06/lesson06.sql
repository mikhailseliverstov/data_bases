USE vk;


/*Задание 2. Подсчитать общее количество лайков, которые получили 10 самых молодых пользователей.*/
SELECT 
	user_id,
	birthday,
	(SELECT
		SUM(lks)
	FROM
		(SELECT
			target_id,
			target_type_id,
			COUNT(id) AS lks,
			CASE
				WHEN target_type_id = 1 
					THEN (SELECT from_user_id FROM messages m WHERE l.target_id = m.id)
				WHEN target_type_id = 2 
					THEN (SELECT id FROM users u WHERE l.target_id = u.id)
				WHEN target_type_id = 3 
					THEN (SELECT user_id FROM media me WHERE l.target_id = me.id)
				WHEN target_type_id = 4 
					THEN (SELECT user_id FROM posts p WHERE l.target_id = p.id)
			END AS userid
		FROM likes l
		GROUP BY target_id, target_type_id) tbl1
	WHERE p2.user_id = userid
	GROUP BY userid) tbl2
FROM profiles p2 
ORDER BY birthday DESC 
LIMIT 10;


/*3. Определить кто больше поставил лайков (всего) - мужчины или женщины?*/
SELECT 
	CASE (SELECT gender FROM profiles p WHERE l.user_id = p.user_id) 
		WHEN 'm' THEN 'male'
		WHEN 'f' THEN 'female'
	END AS gender,	
	(SELECT name FROM target_types t WHERE l.target_type_id = t.id) AS media_type,
	COUNT(id) AS likes	
FROM likes l
GROUP BY gender, media_type
ORDER BY gender, media_type ASC;


/*4. Найти 10 пользователей, которые проявляют наименьшую активность в использовании социальной сети.*/
SELECT 
	id, name, friends, grps, -unred_msgs, sent_msgs, posts, likes,
	friends + grps - unred_msgs + sent_msgs + posts + likes AS total_score
FROM
	(SELECT
		u.id,
		CONCAT(first_name, ' ', last_name) AS name,
		(SELECT COUNT(friend_id) FROM friendship f2 WHERE u.id = f2.user_id) AS friends,
		(SELECT COUNT(community_id) FROM communities_users cu WHERE u.id = cu.user_id) AS grps,
		(SELECT COUNT(id) FROM messages m WHERE is_delivered = 0 AND u.id = m.to_user_id) AS unred_msgs,
		(SELECT COUNT(id) FROM messages m WHERE is_delivered != 0 AND u.id = m.to_user_id) AS sent_msgs,
		(SELECT COUNT(id) FROM posts p WHERE u.id = p.user_id) AS posts,
		(SELECT COUNT(id) AS likes FROM likes l WHERE u.id = l.user_id) AS likes
	FROM users u) tbl
ORDER BY total_score ASC
LIMIT 10;
