USE vk;

-- 1. ���������������� ����� ������� ����� ����������� �������� ����� � �������� ������ ���������� � �������� ����������� �������.

CREATE UNIQUE INDEX users_email_idx ON users(email); -- ��������� � �����, ���������� ��� �������� ������� �������� �������������
CREATE UNIQUE INDEX users_first_name_last_name_idx ON users(first_name,last_name); -- ������ ���������� ��� ������ ������������ � ���������� VK
CREATE INDEX profiles_birthday_idx ON profiles(birthday); -- ������� ������ ������� �� �����

-- 2. ������� �� ������� �������

SELECT
	c.name, -- ��� ������
	COUNT(cu.user_id) OVER() / MAX(c.id) OVER() AS avg_users, -- ������� ���������� ������������� � �������
	MAX(p.birthday) OVER w AS youngest_user, -- ����� ������� ������������ � ������
	MIN(p.birthday) OVER w AS oldest_user, -- ����� ������� ������������ � ������
	COUNT(cu.user_id) OVER w AS cnt_users,-- ���������� ������������� � ������
	COUNT(p.user_id) OVER() AS total_users,-- ����� ������������� � �������
	((COUNT(cu.user_id) OVER w) / (COUNT(p.user_id) OVER())) * 100 AS '%%'-- ��������� � ��������� (���������� ������������� � ������ / ����� ������������� � �������) * 100
FROM communities_users cu
LEFT JOIN communities c ON cu.community_id = c.id 
LEFT JOIN profiles p ON cu.user_id = p.user_id 
	WINDOW w AS (PARTITION BY cu.community_id);  

SELECT community_id, COUNT(user_id) FROM communities_users cu GROUP BY community_id ;
SELECT COUNT(id) FROM users;
SELECT * FROM communities;

-- 3. ����������� ��� �������� � �������� ��������� ������:
-- ����� 10 �������������, ������� ��������� ���������� ���������� � ������������� ���������� ����.

SELECT users.id,
	COUNT(DISTINCT messages.id) + COUNT(DISTINCT likes.id) + COUNT(DISTINCT media.id) AS activity
FROM users
LEFT JOIN messages ON users.id = messages.from_user_id
LEFT JOIN likes	ON users.id = likes.user_id
LEFT JOIN media	ON users.id = media.user_id
GROUP BY users.id
ORDER BY activity
LIMIT 10;

-- �� ����������� �� ����������� ������� ������� - ������������� ��������� �������� ��������� �� ������������� ��� JOIN'��
-- � ���������� ��������� (�����������, �����������) ���������� "��������" �������. �������� ���������� ������� � ��� ���� ����, ��� � ���������.

SELECT 
	id,
	(SELECT COUNT(id) FROM messages m WHERE u.id = m.from_user_id) +
	(SELECT COUNT(id) FROM likes l WHERE u.id = l.user_id) +
	(SELECT COUNT(id) FROM media md WHERE u.id = md.user_id) AS activity
FROM users u
ORDER BY activity ASC
LIMIT 10;

-- ����������� �� ��������������:
-- 1. ������� �� ������� messages ���� body � ��������� ������� � ������ message_id, body. ��� ������� ��������� �� �������� ��������� �� �����.
-- 2. ���������� ������� likes � target_types
-- 3. ���������� ������� media � media_types
