USE vk;


ALTER TABLE profiles
  ADD CONSTRAINT profiles_user_id_fk 
    FOREIGN KEY (user_id) REFERENCES users(id)
      ON DELETE CASCADE, -- ���� �� ������� id �����, �� ������ ������� ��� ������ � ��
  ADD CONSTRAINT profiles_photo_id_fk
    FOREIGN KEY (photo_id) REFERENCES media(id)
      ON DELETE SET NULL; -- ���� ���� ������� ���� �������, �� �� ������ ���������� NULL ��� ���������� ����������
      
ALTER TABLE profiles DROP FOREIGN KEY profles_user_id_fk;
ALTER TABLE profiles MODIFY COLUMN photo_id INT(10) UNSIGNED;

ALTER TABLE media
  ADD CONSTRAINT media_media_type_id_fk 
    FOREIGN KEY (media_type_id) REFERENCES media_types(id)
      ON DELETE CASCADE,  -- ���� �� ������� ��� �����, �� ������ ������� ��� ����� ����� ����
  ADD CONSTRAINT media_user_id_fk
    FOREIGN KEY (user_id) REFERENCES users(id)
      ON DELETE CASCADE; -- ���� �� ������� id �����, �� ������ ������� ��� ��� �����
      
     
ALTER TABLE friendship
	ADD CONSTRAINT friendship_status_id_fk 
		FOREIGN KEY (status_id) REFERENCES friendship_statuses(id)
			ON DELETE CASCADE -- ���� ������� ������ ������ (��� ������), �� ������� ��� ������ � ����� ��������
			ON UPDATE CASCADE, -- ���� ��������� ������ ������, �� ��������� � ������� friendship
	ADD CONSTRAINT friendship_user_id_fk 
    	FOREIGN KEY (user_id) REFERENCES users(id)
      		ON DELETE CASCADE, -- ���� ������� id �����, �� ������� ��� ��� ������ � ��� ������ � ���-��
  	ADD CONSTRAINT friendship_frien_id_fk 
    	FOREIGN KEY (friend_id) REFERENCES users(id)
      		ON DELETE CASCADE; -- ���� ������� id �����, �� ������� ��� ������������ ��� ������ � ������

ALTER TABLE communities_users 
	ADD CONSTRAINT communities_users_user_id_fk 
    	FOREIGN KEY (user_id) REFERENCES users(id)
      		ON DELETE CASCADE, -- ���� �� ������� �����, �� ������� ��� ��� �������������� � �������
	ADD CONSTRAINT communities_users_community_id_fk
    	FOREIGN KEY (community_id) REFERENCES communities(id)
      		ON DELETE CASCADE; -- ���� �� ������� ������, �� ������� ��� �������������� ������ � ���
      		
ALTER TABLE likes
	ADD CONSTRAINT likes_user_id_fk 
    	FOREIGN KEY (user_id) REFERENCES users(id)
      		ON DELETE CASCADE, -- ���� �� ������� �����, �� ������� ��� ��� �����
	ADD CONSTRAINT likes_target_type_id_fk
    	FOREIGN KEY (target_type_id) REFERENCES target_types(id)
      		ON DELETE CASCADE; -- ���� �� ������� ��� ��������� ��������, �� ������ ������� ��� ����� ����� ����
      		
ALTER TABLE messages 
	MODIFY COLUMN from_user_id INT UNSIGNED DEFAULT NULL,
	MODIFY COLUMN to_user_id INT UNSIGNED DEFAULT NULL;

      		
ALTER TABLE messages 
	ADD CONSTRAINT messages_from_user_id_fk
		FOREIGN KEY (from_user_id) REFERENCES users(id)
			ON DELETE SET NULL, -- ���� ������� �����, �� �������� ��� ����������� ���� ��� ���������
	ADD CONSTRAINT messages_to_user_id_fk
		FOREIGN KEY (to_user_id) REFERENCES users(id)
			ON DELETE SET NULL; -- ���� ������� �����, �� �������� ��� ���������� ���� ��������� ���
		
		
ALTER TABLE posts 
	ADD CONSTRAINT posts_user_id_fk
		FOREIGN KEY (user_id) REFERENCES users(id)
			ON DELETE CASCADE, -- ���� ������� �����, �� ������� ��� ��� �����
	ADD CONSTRAINT posts_media_id_fk
		FOREIGN KEY (media_id) REFERENCES media(id)
			ON DELETE CASCADE; -- ���� ������� ��� ����� �����, �� ������� ��� ����� ����� ����

			
ALTER TABLE communities
  ADD CONSTRAINT communities_media_id_fk 
    FOREIGN KEY (media_id) REFERENCES media(id)
    	ON DELETE SET NULL;

/*      
ALTER TABLE profiles DROP FOREIGN KEY profiles_user_id_fk;
ALTER TABLE profiles DROP FOREIGN KEY profiles_photo_id_fk;
ALTER TABLE media DROP FOREIGN KEY media_media_type_id_fk;
ALTER TABLE media DROP FOREIGN KEY media_user_id_fk;
ALTER TABLE friendship DROP FOREIGN KEY friendship_status_id_fk;
ALTER TABLE friendship DROP FOREIGN KEY friendship_user_id_fk;
ALTER TABLE friendship DROP FOREIGN KEY friendship_frien_id_fk;
ALTER TABLE messages 
	DROP FOREIGN KEY messages_from_user_id_fk, 
	DROP FOREIGN KEY messages_to_user_id_fk;
*/
 