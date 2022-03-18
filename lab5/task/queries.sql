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

SELECT * FROM hotel
    INNER JOIN client