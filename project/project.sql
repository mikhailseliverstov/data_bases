CREATE DATABASE my_db;
USE my_db;

-- Создаём таблицу клиентов
DROP TABLE IF EXISTS customers;
CREATE TABLE customers (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	email VARCHAR(120) NOT NULL UNIQUE,
	phone VARCHAR(120) NOT NULL,
	created_at DATETIME DEFAULT NOW(),
	updated_at DATETIME DEFAULT NOW() ON UPDATE NOW()  
);

-- Таблица профилей
DROP TABLE IF EXISTS profiles;
CREATE TABLE profiles (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  customer_id INT UNSIGNED NOT NULL,
  first_name VARCHAR(120) NOT NULL,
  last_name VARCHAR(120) NOT NULL,
  gender CHAR(1) NOT NULL,
  birthday DATE,
  city VARCHAR(100),
  country VARCHAR(100),
  created_at DATETIME DEFAULT NOW(),
  updated_at DATETIME DEFAULT NOW() ON UPDATE NOW(),
  CONSTRAINT profiles_customer_id_fk FOREIGN KEY (customer_id) REFERENCES customers(id)
);


-- Таблица типов устройств
DROP TABLE IF EXISTS devices_type;
CREATE TABLE devices_type (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	device_name VARCHAR(50)
);


-- Таблица покупок с сайта
DROP TABLE IF EXISTS transactions;
CREATE TABLE transactions (
	id INT UNSIGNED NOT NULL PRIMARY KEY,
	utm_source VARCHAR(100),
	utm_medium VARCHAR(100),
	utm_campaign VARCHAR(100),
	utm_term VARCHAR(100),
	device_type_id INT UNSIGNED NOT NULL,
	google_click_id VARCHAR(100),
	yandex_click_id VARCHAR(100),
	created_at DATETIME DEFAULT NOW(),
  	updated_at DATETIME DEFAULT NOW() ON UPDATE NOW(),
  	CONSTRAINT transactions_device_type_id_fk FOREIGN KEY (device_type_id) REFERENCES devices_type(id)
);


-- Таблица заказов
DROP TABLE IF EXISTS orders;
CREATE TABLE orders (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	transaction_id INT UNSIGNED NOT NULL,
	customer_id INT UNSIGNED NOT NULL,
	promo VARCHAR(100),
	created_at DATETIME DEFAULT NOW(),
  	updated_at DATETIME DEFAULT NOW() ON UPDATE NOW(),
  	CONSTRAINT orders_transaction_id_fk FOREIGN KEY (transaction_id) REFERENCES transactions(id),
  	CONSTRAINT orders_customer_id_fk FOREIGN KEY (customer_id) REFERENCES customers(id)
);


-- Таблица названий и адресов мест отправления/прибытия
DROP TABLE IF EXISTS cities;
CREATE TABLE cities (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	city_name VARCHAR(50),
	region_name VARCHAR(50),
	country_name VARCHAR(50),
	address VARCHAR(100)
);


-- Таблица перевозчиков
DROP TABLE IF EXISTS carriers;
CREATE TABLE carriers (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	carrier_name VARCHAR(50)
);


-- Таблица с маршрутами
DROP TABLE IF EXISTS routes;
CREATE TABLE routes (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	from_city_id INT UNSIGNED NOT NULL,
	to_city_id INT UNSIGNED NOT NULL,
	price FLOAT,
	CONSTRAINT routes_from_city_id_fk FOREIGN KEY (from_city_id) REFERENCES cities(id),
	CONSTRAINT routes_to_city_id_fk FOREIGN KEY (to_city_id) REFERENCES cities(id)
);


-- Таблица бронирований
DROP TABLE IF EXISTS bookings;
CREATE TABLE bookings (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	order_id INT UNSIGNED NOT NULL,
	total_cents FLOAT,
	customer_data VARCHAR(200), -- имя, фамилия, данные паспорта пассажира
	from_city_id INT UNSIGNED NOT NULL,
	to_city_id INT UNSIGNED NOT NULL,
	carrier_id INT UNSIGNED NOT NULL,
	route_id INT UNSIGNED NOT NULL,
	departure_time DATETIME,
	state VARCHAR(10), -- статус бронирования: ticketed, returned, voided, booked
	created_at DATETIME DEFAULT NOW(),
	updated_at DATETIME DEFAULT NOW() ON UPDATE NOW(),
	CONSTRAINT bookings_order_id_fk FOREIGN KEY (order_id) REFERENCES orders(id),
	CONSTRAINT bookings_carrier_id_fk FOREIGN KEY (carrier_id) REFERENCES carriers(id),
	CONSTRAINT bookings_route_id_fk FOREIGN KEY (route_id) REFERENCES routes(id),
	CONSTRAINT bookings_from_city_id_fk FOREIGN KEY (from_city_id) REFERENCES cities(id),
	CONSTRAINT bookings_to_city_id_fk FOREIGN KEY (to_city_id) REFERENCES cities(id)
);


-- Данные из рекламных кабинетов
DROP TABLE IF EXISTS analytics;
CREATE TABLE analytics (
	date DATE,
	utm_source VARCHAR(100),
	utm_medium VARCHAR(100),
	utm_campaign VARCHAR(100),
	utm_content VARCHAR(150),
	utm_term VARCHAR(100),
	device_name VARCHAR(100),
	cost FLOAT,
	impressions INT,
	clicks INT
);

