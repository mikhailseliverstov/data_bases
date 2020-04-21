
#Выборка пользователей с заказами в статусе "ticketed"
SELECT
	c.id,
	CONCAT(p.first_name, " ", p.last_name) AS name,
	COUNT(o.id) AS total_orders
FROM customers c
LEFT JOIN orders o ON c.id = o.customer_id
LEFT JOIN bookings b ON o.id = b.order_id 
JOIN profiles p ON c.id = p.customer_id
WHERE b.state = "ticketed"
GROUP BY c.id, name
ORDER BY total_orders DESC;


#Отчёт по заказам с разбивкой по каналам привлечения (Заказов получилось не слишком много, поэтому уменьшил количество параметров сегментации)
SELECT 
	-- date,
	a.utm_source AS source,
	a.utm_medium AS channel,
	-- a.device_name,
	SUM(impressions) AS impr,
	SUM(clicks) AS clicks,
	ROUND(SUM(cost), 2) AS cost,
	COUNT(t.id) AS orders
FROM analytics a 
LEFT JOIN transactions t ON a.date = CONVERT(t.created_at, DATE) AND a.utm_source = t.utm_source AND a.utm_medium = t.utm_medium -- AND a.utm_campaign = t.utm_campaign -- AND a.device_name = dt.device_name 
-- LEFT JOIN devices_type dt ON t.device_type_id = dt.id 
GROUP BY /* date, */ source, channel -- , device_name
ORDER BY /* date, */ source, channel -- , device_name
;


#Запрос статистики заказов в разных статусах
SELECT 
	customer_id,
	(SELECT CONCAT(p.first_name, " ", p.last_name) FROM profiles p WHERE p.customer_id = o.customer_id) AS name,
	COUNT(o.id) AS sum_orders,
	COUNT(CASE WHEN b.state = "ticketed" THEN 1 ELSE NULL END) AS ticketed,
	COUNT(CASE WHEN b.state = "returned" THEN 1 ELSE NULL END) AS returned,
	COUNT(CASE WHEN b.state = "voided" THEN 1 ELSE NULL END) AS voided,
	COUNT(CASE WHEN b.state = "booked" THEN 1 ELSE NULL END) AS booked
FROM orders o
LEFT JOIN bookings b ON o.id = b.order_id 
GROUP BY o.customer_id, name;



#Запрос статистики заказов  разрезе направлений
SELECT 
	CONCAT(c.city_name , " - ", c1.city_name ) AS route_name,
	ROUND(r.price,1) AS price,
	COUNT(b.order_id) AS sum_orders
FROM bookings b
LEFT JOIN routes r ON b.route_id = r.id
LEFT JOIN cities c ON c.id = r.from_city_id 
LEFT JOIN cities c1 ON c1.id = r.to_city_id 
GROUP BY route_name, r.price
ORDER BY sum_orders DESC;



#Представление для ежедневного мониторинга маркетинговых показателей
DROP VIEW IF EXISTS marketing_report;
CREATE VIEW marketing_report AS
SELECT
	a.date,
	t.utm_source AS source,
	t.utm_medium AS channel,
	SUM(impressions) AS impr,
	SUM(clicks) AS clicks,
	ROUND(SUM(cost), 2) AS cost,
	COUNT(o.id) AS orders,
	ROUND(SUM(cost) / SUM(clicks), 1) AS cost_per_click,
	ROUND(SUM(cost) / COUNT(t.id), 2) AS cost_per_order,
	SUM(new_order) AS new_orders,
	ROUND(SUM(cost) / SUM(new_order), 2) AS customer_acquisition_cost
FROM transactions t
LEFT JOIN analytics a ON a.date = CONVERT(t.created_at, DATE) AND a.utm_source = t.utm_source AND a.utm_medium = t.utm_medium
LEFT JOIN orders o ON t.id = o.transaction_id 
LEFT JOIN (SELECT
				CONVERT(created_at, DATE) AS date,
				CASE 
					WHEN ROW_NUMBER() OVER(PARTITION BY o1.customer_id ORDER BY o1.created_at ASC) = 1
						THEN 1
						ELSE 0
				END AS new_order
			FROM orders o1) tbl ON a.`date` = tbl.date
GROUP BY date, source, channel
ORDER BY date DESC, source, channel;


#Представление для отслеживания количества "отваливающихся" клиентов
DROP VIEW IF EXISTS churn;
CREATE VIEW churn AS
SELECT
	tbl.created_at,
	SUM(churn_users) AS new_churn,
	SUM(churn_users) OVER(ORDER BY created_at ASC RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS churn_users 
FROM (
		SELECT 
			created_at,
			DATEDIFF(CURRENT_TIMESTAMP(), MAX(created_at) OVER(PARTITION BY customer_id)) delay,
			CASE WHEN DATEDIFF(CURRENT_TIMESTAMP(), MAX(o.created_at) OVER(PARTITION BY customer_id)) > 90
				THEN 1
				ELSE 0
			END AS churn_users
		FROM orders o) tbl
GROUP BY created_at
ORDER BY created_at DESC;


#Триггер на проверку существования пользователя в базе
DELIMETER -
CREATE TRIGGER customer_chek BEFORE INSERT ON customers
FOR EACH ROW
BEGIN 
	DECLARE @cnt VARCHAR(120) DEFAULT 0;
	SELECT COUNT(*) INTO @cnt FROM customers WHERE phone = NEW.phone;
	IF @cnt > 0 THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'User already exist';
	END IF;
END-
DELIMETER ;

