-- 3.1 INSERT
-- a. Без указания списка полей
-- INSERT INTO table_name VALUES (value1, value2, value3, ...);
INSERT INTO prisoner
VALUES (9999, 'Prisoner Name', 1, '1980-12-31');

-- b. С указанием списка полей
-- INSERT INTO table_name (column1, column2, column3, ...) VALUES (value1, value2, value3, ...);
INSERT INTO prisoner(name, status, date_of_birth)
VALUES ('Prisoner Name 2', 1, '1950-12-31');

-- c. С чтением значения из другой таблицы
-- INSERT INTO table2 (column_name(s)) SELECT column_name(s) FROM table1;
INSERT INTO prisoner(name, status, date_of_birth)
SELECT name, status, date_of_birth
FROM prisoner_mock;

-- 3.2 DELETE
-- a. Всех записей
# noinspection SqlWithoutWhere
DELETE
FROM prisoner;

-- b. По условию DELETE FROM table_name WHERE condition;
DELETE
FROM prisoner
WHERE status = 0;

-- 3.3. UPDATE
-- a. Всех записей
# noinspection SqlWithoutWhere
UPDATE prisoner
SET status=3;

-- b. По условию обновляя один атрибут
-- UPDATE table_name SET column1 = value1, column2 = value2, ... WHERE condition;
UPDATE prisoner
SET status=1
WHERE date_of_birth <= '1990-01-01';

-- 3.4. SELECT
-- a. С набором извлекаемых атрибутов (SELECT atr1, atr2 FROM...)
SELECT name,
       date_of_birth
FROM prisoner;

-- b. Со всеми атрибутами (SELECT * FROM...)
SELECT *
FROM prisoner;

-- c. С условием по атрибуту (SELECT * FROM ... WHERE atr1 = value)
SELECT *
FROM prisoner
WHERE date_of_birth <= '1990-01-01';

-- 3.5. SELECT ORDER BY + TOP (LIMIT)
-- a. С сортировкой по возрастанию ASC + ограничение вывода количества записей
SELECT *
FROM prisoner
ORDER BY date_of_birth
LIMIT 5;

-- b. С сортировкой по убыванию DESC
SELECT *
FROM prisoner
ORDER BY date_of_birth DESC
LIMIT 5;

-- c. С сортировкой по двум атрибутам + ограничение вывода количества записей
SELECT *
FROM prisoner
ORDER BY status, date_of_birth DESC
LIMIT 5;

-- d. С сортировкой по первому атрибуту, из списка извлекаемых
SELECT date_of_birth, name
FROM prisoner
ORDER BY date_of_birth DESC;

-- 3.6. Работа с датами
-- Необходимо, чтобы одна из таблиц содержала атрибут с типом DATETIME. Например,
-- таблица авторов может содержать дату рождения автора.
-- a. WHERE по дате
SELECT *
FROM imprisonment
WHERE end_of_term = '2023-06-11 06:46:07';

-- b. WHERE дата в диапазоне
SELECT *
FROM imprisonment
WHERE end_of_term BETWEEN '2025-01-01' AND '2030-01-01';

-- c. Извлечь из таблицы не всю дату, а только год. Например, год рождения автора.
-- Для этого используется функция YEAR
SELECT p.name,
       YEAR(i.end_of_term)
FROM imprisonment i
         INNER JOIN prisoner p ON i.prisoner_id = p.prisoner_id
WHERE end_of_term BETWEEN '2020-01-01 00:00:00' AND '2030-01-01 00:00:00';

-- 3.7. Функции агрегации
-- a. Посчитать количество записей в таблице
SELECT COUNT(`name`)
FROM prisoner;

-- b. Посчитать количество уникальных записей в таблице
SELECT COUNT(DISTINCT `name`)
FROM prisoner;

-- c. Вывести уникальные значения столбца
SELECT DISTINCT `name`
FROM prisoner;

-- d. Найти максимальное значение столбца
SELECT MAX(date_of_birth)
FROM prisoner;

-- e. Найти минимальное значение столбца
SELECT MIN(date_of_birth)
FROM prisoner;

-- f. Написать запрос COUNT() + GROUP BY
SELECT c.name,
       COUNT(c.name)
FROM criminal_to_case ctc
         INNER JOIN criminal c ON ctc.criminal_id = c.criminal_id
GROUP BY c.criminal_id;

-- 3.8. SELECT GROUP BY + HAVING
-- a. Написать 3 разных запроса с использованием GROUP BY + HAVING. Для
-- каждого запроса написать комментарий с пояснением, какую информацию
-- извлекает запрос. Запрос должен быть осмысленным, т.е. находить информацию,
-- которую можно использовать.

-- Количество дел по статей
SELECT c.name, COUNT(c.criminal_id) AS cases_amount
FROM `case`
         INNER JOIN criminal_to_case ctc ON `case`.case_id = ctc.case_id
         INNER JOIN criminal c ON ctc.criminal_id = c.criminal_id
GROUP BY c.criminal_id
HAVING COUNT(c.criminal_id) > 4;

-- Количество дел со свидетелями больше чем 1
SELECT c.name, COUNT(e.evidence_id)
FROM `case` c
         LEFT JOIN evidence e ON c.case_id = e.case_id
GROUP BY c.case_id
HAVING COUNT(e.evidence_id) > 1;

-- Количество заключений у заключенных, имеющих больше 1 срока
SELECT p.name,
       COUNT(p.prisoner_id)
FROM prisoner p
         LEFT JOIN imprisonment i ON p.prisoner_id = i.prisoner_id
GROUP BY p.prisoner_id
HAVING COUNT(i.prisoner_id) > 1;

-- 3.9. SELECT JOIN
-- a. LEFT JOIN двух таблиц и WHERE по одному из атрибутов
SELECT c.case_id,
       c.name,
       COUNT(e.evidence_id)
FROM `case` c
         LEFT JOIN evidence e ON c.case_id = e.case_id
GROUP BY c.case_id;

-- b. RIGHT JOIN. Получить такую же выборку, как и в 3.9 a
SELECT c.case_id,
       c.name,
       COUNT(e.evidence_id)
FROM evidence e
         RIGHT JOIN `case` c ON c.case_id = e.case_id
GROUP BY c.case_id;

-- c. LEFT JOIN трех таблиц + WHERE по атрибуту из каждой таблицы
SELECT p.prisoner_id,
       p.name,
       COUNT(i.imprisonment_id)
FROM prisoner p
         LEFT JOIN imprisonment i on p.prisoner_id = i.prisoner_id
         LEFT JOIN `case` c on i.imprisonment_id = c.imprisonment_id
WHERE (p.date_of_birth BETWEEN '1990-01-01' AND '2000-01-01')
  AND c.name LIKE '%кража%'
  AND (i.start_of_term BETWEEN '2010-01-01' AND '2020-01-01')
GROUP BY p.prisoner_id;


-- d. INNER JOIN двух таблиц
SELECT c.name,
       COUNT(c.name)
FROM criminal_to_case ctc
         INNER JOIN criminal c ON ctc.criminal_id = c.criminal_id
GROUP BY c.criminal_id;

-- 3.10. Подзапросы
-- a. Написать запрос с условием WHERE IN (подзапрос)
SELECT name
FROM prisoner
WHERE status IN (0, 1);

-- b. Написать запрос SELECT atr1, atr2, (подзапрос) FROM ...
SELECT `name`,
       `description`,
       (
           SELECT victim_name
           FROM evidence e
           WHERE c.case_id = e.case_id
           ORDER BY date_of_given DESC
           LIMIT 1
       ) AS name
FROM `case` c;

-- c. Написать запрос вида SELECT * FROM (подзапрос)
SELECT d.start_of_term,
       d.end_of_term,
       DATEDIFF(d.end_of_term, d.start_of_term) AS days_of_imprisonment
FROM (
         SELECT i.start_of_term,
                i.end_of_term
         FROM imprisonment i
     ) d;

-- d. Написать запрос вида SELECT * FROM table JOIN (подзапрос) ON …
SELECT *
FROM imprisonment i
         LEFT JOIN (SELECT * FROM prisoner) p ON p.prisoner_id = i.prisoner_id;
