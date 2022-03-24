-- 1. Добавить внешние ключи
# Pk
ALTER TABLE booking
ADD PRIMARY KEY pk_booking(id_booking);

ALTER TABLE client
ADD PRIMARY KEY pk_client(id_client);

ALTER TABLE hotel
ADD PRIMARY KEY pk_hotel(id_hotel);

ALTER TABLE room
ADD PRIMARY KEY pk_room(id_room);

ALTER TABLE room_category
ADD PRIMARY KEY pk_room_category(id_room_category);

ALTER TABLE room_in_booking
ADD PRIMARY KEY pk_room_in_booking(id_room_in_booking);

# FK
ALTER TABLE room_in_booking
ADD FOREIGN KEY (id_room) REFERENCES room(id_room);

ALTER TABLE room_in_booking
ADD FOREIGN KEY (id_booking) REFERENCES booking(id_booking);

ALTER TABLE room
ADD FOREIGN KEY (id_room_category) REFERENCES room_category(id_room_category);

ALTER TABLE room
ADD FOREIGN KEY (id_room_category) REFERENCES room_category(id_room_category);

ALTER TABLE room
ADD FOREIGN KEY (id_hotel) REFERENCES hotel(id_hotel);

ALTER TABLE booking
ADD FOREIGN KEY (id_client) REFERENCES client(id_client);

-- 2. Выдать информацию о клиентах гостиницы “Космос”, проживающих в номерах
-- категории “Люкс” на 1 апреля 2019г.
SELECT c.*
FROM hotel h
  INNER JOIN room r ON h.id_hotel = r.id_hotel
  INNER JOIN room_category rc ON r.id_room_category = rc.id_room_category
  INNER JOIN room_in_booking rib on r.id_room = rib.id_room
  INNER JOIN booking b on rib.id_booking = b.id_booking
  INNER JOIN client c on b.id_client = c.id_client
WHERE h.name = 'Космос'
  AND rc.name='Люкс'
  AND rib.checkin_date <= '2019.04.01'
  AND rib.checkout_date >= '2019.04.01';

-- 3. Дать список свободных номеров всех гостиниц на 22 апреля
SELECT h.name,
       r.id_room
FROM room r
  INNER JOIN hotel h on r.id_hotel = h.id_hotel
  LEFT JOIN room_in_booking rib ON r.id_room = rib.id_room
WHERE rib.checkout_date < '2019.04.22'
  OR rib.checkin_date > '2019.04.22'
GROUP BY r.id_hotel, r.id_room;

-- 4.Дать количество проживающих в гостинице “Космос” на 23 мартапо каждой категории номеров
SELECT
  rc.name,
  COUNT(rib.id_room_in_booking)
FROM room r
  INNER JOIN hotel h ON r.id_hotel = h.id_hotel
  INNER JOIN room_category rc ON r.id_room_category = rc.id_room_category
  INNER JOIN room_in_booking rib ON r.id_room = rib.id_room
WHERE rib.checkin_date < '2019.03.23'
  AND rib.checkout_date > '2019.03.23'
GROUP BY rc.id_room_category;

-- 5. Дать список последних проживавших клиентов по всем комнатам гостиницы
-- “Космос”, выехавшим в апреле с указанием даты выезда.
SELECT h.name,
       r.number,
       c.name,
       rib.checkout_date
FROM (
     SELECT rib.id_room AS id_room,
            MAX(rib.checkout_date) AS checkout_date
     FROM room_in_booking rib
     GROUP BY rib.id_room
  ) AS last_room_booking
  INNER JOIN room_in_booking rib ON rib.id_room = last_room_booking.id_room AND last_room_booking.checkout_date = rib.checkout_date
  INNER JOIN booking b ON rib.id_booking = b.id_booking
  INNER JOIN client c ON b.id_client = c.id_client
  INNER JOIN room r ON rib.id_room = r.id_room
  INNER JOIN hotel h ON r.id_hotel = h.id_hotel
WHERE h.name='Космос'
  AND (rib.checkout_date BETWEEN '2019.05.01' AND '2019.05.31');

-- 6. Продлить на 2 дня дату проживания в гостинице “Космос” всем клиентам комнат категории
-- “Бизнес”, которые заселились 10 мая.
UPDATE room_in_booking rib
  INNER JOIN room r on rib.id_room = r.id_room
  INNER JOIN hotel h on r.id_hotel = h.id_hotel
  INNER JOIN room_category rc on r.id_room_category = rc.id_room_category
SET rib.checkout_date=DATE_ADD(rib.checkout_date, INTERVAL 2 DAY)
WHERE h.name='Космос'
  AND rib.checkin_date = '2019.05.10'
  AND rc.name='Бизнес';

-- 7. Найти все "пересекающиеся" варианты проживания. Правильное состояние: не может
-- быть забронирован один номер на одну дату несколько раз, т.к. нельзя заселиться нескольким
-- клиентам в один номер. Записи в таблице room_in_booking с id_room_in_booking = 5 и 2154
-- являются примером неправильного с остояния, которые необходимо найти. Результирующий
-- кортеж выборки должен содержать информацию о двух конфликтующих номерах.

-- 8. Создать бронирование в транзакции
START TRANSACTION;
INSERT INTO booking(id_booking, id_client, booking_date)
VALUES (10001, 1, '2022.03.25');
INSERT INTO room_in_booking(id_room_in_booking, id_booking, id_room, checkin_date, checkout_date)
VALUES (100001, 10001, 1, '2022.04.01', '2022.04.08');
COMMIT;

-- 9. Добавить необходимые индексы для всех таблиц
