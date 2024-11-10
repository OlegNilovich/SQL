---------------------------------------------------------------------------------------------------
---- РАБОТА С БД ЧЕРЕЗ КОМАНДНУЮ СТРОКУ -----------------------------------------------------------

-- PSQL  -  консольная утилита для управления базой данных Postgres.
-- Чтобы не указывать полный путь к PSQL, лучше добавить ее в переменные среды PATH
-- Пример пути:      C:\MyPrograms\OSPanel\modules\database\PostgreSQL-14-Win10\bin

-- PSQL Команды:
-- (Список команд)               psql --help
-- (Подключиться к БД)           psql -U postgres -d postgres -h localhost -p 5432
-- (Отключиться от БД)           exit  \q
-- (Список таблиц)               \l  \d  \dt
-- (Описание таблицы)            \d название_таблицы
-- (Создание БД)                 psql -U postgres --command "create database new_companies"
-- (Загрузка дампа в пустую ДБ)  psql -U postgres -d new_companies -f companies.sql

-- PG_DUMP  -  консольная утилита для создания дампов баз данных
-- PG_DUMP Команды:

-- (Создание дампа базы данных в текущей директории где открыта консоль)
-- pg_dump --host localhost --port 5432 --username postgres --dbname companies > companies.sql
-- (Посмотреть содержимое дампа базы данных)   cat companies.sql


---------------------------------------------------------------------------------------------------
---- СОЧИТАНИЯ КЛАВИШ И СНИППЕТЫ ------------------------------------------------------------------

--(Форматирование кода)     Ctrl + Alt + L
--(Дублировать строку)      Ctrl + D
--(Сдвинуть строку)         Shift + Ctrl + Вверх или Вниз
--(Быстрая вставка записи)  "ins" + Tab

---------------------------------------------------------------------------------------------------
---- ТИПЫ ДАННЫХ - Набор множества значений, которые могут использоваться в конкретном поле -------

--SERIAL, BIG SERIAL, SMALL SERIAL - Числовой, автоинкриментируемый тип (заполняется автоматически)
--INT, BIGINT, SMALLINT          - Числовой тип
--TEXT                           - Текстовый тип
--VARCHAR(128)                   - Текстовый тип ограниченной длинны (указывается в скобках)
--DATE                           - Тип дата (2024-04-29)
--TIME                           - Тип время (21:59:59)
--TIMESTAMP                      - Тип дата и время (2024-04-29 21:59:59)

---------------------------------------------------------------------------------------------------
---- CONSTRAINTS - ОГРАНИЧЕНИЯ, указываются после типов полей во время создания таблицы -----------

--NOT NULL - Поле не может быть без значения, заполнение обязательно.
--UNIQUE - Значение поля должно быть уникальным.
--CHECK (age > 18) - Условие для значения поля. Пример: нельзя ввести возраст меньше 18.
--PRIMARY KEY - Первичный ключ, это совокупность двух ограничений UNIQUE и NOT NULL
--FOREIGN KEY (company_id) REFERENCES company (id) - Первый способ установки внешнего ключа
--REFERENCES company_id (id) - Второй способ. Внешний ключ, указывает на поле в др. таблице
--ON DELETE CASCADE - Доп опция для внешнего ключа (каскадное удаление связанных записей)
-- SET NULL - Доп опция для внешнего ключа (устанавливает значение внешнего ключа в NULL)

---------------------------------------------------------------------------------------------------
---- ОПЕРАТОРЫ ------------------------------------------------------------------------------------

-- SELECT поле1, поле2 - Выбрать поля перечисленные через запятую. * Выберет все поля
-- SELECT поле1, поле2 DISTINCT - Выбрать только уникальные значения полей
-- FROM таблица - Из таблицы
-- WHERE NOT условие AND условие OR условие - Набор условий
-- IN (1, 2, 3, 4) - Значения должны быть в списке
-- LIKE 'P%ov' -- И где фамилия начинается на 'P' и заканчивается на 'ov'
-- BETWEEN значение AND значение - Диапозон от значения до значения
-- IS NOT NULL -- Значение не равняется NULL
-- ORDER BY поле DESC -- Сортировка по полю по убыванию
-- ORDER BY поле ASC -- Сортировка по полю по возрастанию
-- OFFSET количество -- Пропускаем определенное количество записей выборки
-- LIMIT количество -- Выбираем первое определенное количество записей выборки
-- RETURNING * -- Возвращает записи после обновления или удаления
-- GROUP BY - Группирует значения колонок, когда мы агрегируем значения в других колонках
-- HAVING - Накладывает условия на записи после группировки, с помощью GROUP BY
-- OVER () Добавляет новую колонку со значением агрегирующей функции, без использования GROUP BY
-- PARTITION BY - Используется для уточнения, среди каких значений использовать агрегатную функцию

---------------------------------------------------------------------------------------------------
---- DDL ОПЕРАЦИИ НАД БАЗАМИ ДАННЫХ - СОЗДАНИЕ, УДАЛЕНИЕ, ИЗМЕНЕНИЕ -------------------------------

DROP DATABASE companies;
CREATE DATABASE companies WITH ENCODING ='UTF8';

---------------------------------------------------------------------------------------------------
---- DDL ОПЕРАЦИИ НАД СХЕМАМИ - СОЗДАНИЕ, УДАЛЕНИЕ, ИЗМЕНЕНИЕ -------------------------------------

DROP SCHEMA company_schema;
CREATE SCHEMA company_schema;

---------------------------------------------------------------------------------------------------
---- DDL ОПЕРАЦИИ НАД ТАБЛИЦАМИ - СОЗДАНИЕ, ИЗМЕНЕНИЕ, УДАЛЕНИЕ -----------------------------------

CREATE TABLE company
(
    id   SERIAL PRIMARY KEY,
    name VARCHAR(128) UNIQUE NOT NULL,
    date DATE                NOT NULL
);

ALTER TABLE company
    ADD COLUMN owner VARCHAR(128);

DROP TABLE company;

-------------------------------------

CREATE TABLE employee
(
    id         BIGSERIAL PRIMARY KEY,
    first_name VARCHAR(128) NOT NULL,
    last_name  VARCHAR(128) NOT NULL,
    salary     INT,
    company_id INT REFERENCES company (id) ON DELETE CASCADE, --Внешний ключ (указатель на компанию)
    UNIQUE (first_name, last_name)                            --Уникальность для сочитания двух полей

);

ALTER TABLE employee
    ADD COLUMN gender INT;

DROP TABLE employee;

---------------------------------

CREATE TABLE contact
(
    id     BIGSERIAL PRIMARY KEY,
    number VARCHAR(128) NOT NULL,
    type   VARCHAR(128)
);

ALTER TABLE contact
    ADD COLUMN type VARCHAR(128);

DROP TABLE contact;

------------------------------------------------------------------

CREATE TABLE employee_contact
(
    employee_id BIGINT REFERENCES employee (id) ON DELETE CASCADE,
    contact_id  BIGINT REFERENCES contact (id) ON DELETE CASCADE
);

ALTER TABLE employee_contact
    ADD COLUMN id INT;

DROP TABLE employee_contact;


---------------------------------------------------------------------------------------------------
---- DDL ОПЕРАЦИИ НАД КОЛОНКАМИ - СОЗДАНИЕ, ИЗМЕНЕНИЕ, УДАЛЕНИЕ -----------------------------------

--Добавляем новую колонку
ALTER TABLE employee
    ADD COLUMN gender INT;

--Изменяем название колонки
ALTER TABLE employee
    RENAME gender TO sex;

--Заполняем значения новой колонки
update employee
set gender = 1
where id <= 5;

update employee
set gender = 0
where id > 5;

--Устанавливаем ограничение NOT NULL, т.к. мы не могли это сделать до заполнения колонок
ALTER TABLE employee
    ALTER COLUMN gender SET NOT NULL;

--Удаляем колонку из таблицы
ALTER TABLE employee
    DROP COLUMN gender;


---------------------------------------------------------------------------------------------------
---- DML ОПЕРАЦИИ НАД ЗАПИСЯМИ В ТАБЛИЦЕ company: СОЗДАНИЕ, ИЗМЕНЕНИЕ, УДАЛЕНИЕ, ЧТЕНИЕ -----------

INSERT INTO company(name, date)
VALUES ('Google', '2001-01-01'),
       ('Apple', '2002-10-29'),
       ('Facebook', '2003-09-13'),
       ('Amazon', '2004-09-13');

UPDATE company
SET name = 'Google',
    date = '2001-01-01'
WHERE id = 1;

DELETE
FROM company
WHERE id > 0;

SELECT *
FROM company;


---------------------------------------------------------------------------------------------------
---- DML ОПЕРАЦИИ НАД ЗАПИСЯМИ В ТАБЛИЦЕ employee: СОЗДАНИЕ, УДАЛЕНИЕ, ИЗМЕНЕНИЕ, ЧТЕНИЕ ----------

INSERT INTO employee (first_name, last_name, salary, company_id)
VALUES ('Ivan', 'Sidorov', 500, 1),
       ('Ivan', 'Ivanov', 1000, 2),
       ('Arni', 'Paramonov', NULL, 2),
       ('Petr', 'Petrov', 2000, 3),
       ('Sveta', 'Svetikova', 1500, NULL),
       ('Roman', 'Petrov', 1200, 2),
       ('Igor', 'Sidorov', 1650, 3),
       ('Den', 'Brown', 1700, 1);

UPDATE employee
SET first_name = 'Ivan',
    last_name  = 'Sidorov',
    salary     = 500,
    company_id = 1
WHERE id = 1;

DELETE
FROM employee
WHERE id > 0;

SELECT *
FROM employee;


---------------------------------------------------------------------------------------------------
---- DML ОПЕРАЦИИ НАД ЗАПИСЯМИ В ТАБЛИЦЕ contact: СОЗДАНИЕ, УДАЛЕНИЕ, ИЗМЕНЕНИЕ, ЧТЕНИЕ ----------

-- СОЗДАНИЕ
INSERT INTO contact (number, type)
VALUES ('234 - 56 - 78', 'домашний'),
       ('987 - 65 - 43', 'рабочий'),
       ('565 - 25 - 91', 'мобильный'),
       ('332 - 55 - 67', NULL),
       ('465 - 11 - 22', NULL);

-- ПРИВЯЗКА РАБОТНИКА К НОМЕРУ ТЕЛЕФОНА
INSERT INTO employee_contact (employee_id, contact_id)
VALUES (1, 1),
       (1, 2),
       (2, 2),
       (2, 3),
       (2, 4),
       (3, 5);

-- ИЗМЕНЕНИЕ
UPDATE contact
SET number = 234 - 56 - 78,
    type   = 'домашний'
WHERE id = 1;

-- УДАЛЕНИЕ
DELETE
FROM contact
WHERE id > 0;

SELECT *
FROM contact;


---------------------------------------------------------------------------------------------------
---- DML ОПЕРАЦИЯ - ЧТЕНИЕ ЗАПИСЕЙ ИЗ ТАБЛИЦ ------------------------------------------------------

SELECT DISTINCT id,                 --Выбираем только уникальные записи
                first_name имя,     --Устанавливаем Псевдоним(Alias) "имя" для поля "first_name"
                last_name  фамилия, --Устанавливаем Псевдоним(Alias) "фамилия" для поля "last_name"
                salary     зарплата --Устанавливаем Псевдоним(Alias) "зарплата" для поля "salary"
FROM employee работники
WHERE id IN (1, 2, 3, 4) -- Выбраем записи, значение айди которых в списке (1, 2, 3, 4)
    AND last_name LIKE 'P%ov' -- И где фамилия начинается на 'P' и заканчивается на 'ov'
    AND salary BETWEEN 1000 AND 1500 -- И где зарплата в диапозоне 1000-1500 (включительно)
    AND company_id IS NOT NULL -- И где айди компании не имеет значение NULL
   OR first_name LIKE 'S%'     -- ИЛИ где имя начинается на 'S'
ORDER BY salary DESC -- Сортируем выборку по полю "зарплата" по убыванию
OFFSET 1 -- Пропускаем первую запись выборки
    LIMIT 2 -- Выбираем первые две записи выборки
;


---------------------------------------------------------------------------------------------------
---- DML ОПЕРАЦИЯ - УДАЛЕНИЕ ЗАПИСЕЙ ИЗ ТАБЛИЦ ----------------------------------------------------

-- Удаляем сотрудников, у которых значение зарплаты равно NULL
DELETE
FROM employee
WHERE salary IS NULL;

-- Удаляем сотрудника, с самой большой зарплатой
DELETE
FROM employee
WHERE salary = (SELECT max(salary) FROM employee);

-- Удаляем компанию ее сотрудников, благодаря настройке внешнего ключа: ON DELETE CASCADE
DELETE
FROM company
WHERE id = 1;


---------------------------------------------------------------------------------------------------
---- DML ОПЕРАЦИЯ - ИЗМЕНЕНИЕ ЗАПИСЕЙ ИЗ ТАБЛИЦ ---------------------------------------------------

-- Изменяем компанию и зарплату для сотрудника под айди 5
UPDATE employee
SET company_id = 2,
    salary     = 1700
WHERE id = 5
RETURNING *;
-- Возвращаем данные измененной строки


---------------------------------------------------------------------------------------------------
---- АГРЕГАТНЫЕ ФУНКЦИИ ---------------------------------------------------------------------------
SELECT count(salary), -- Возвращает количество строк
       sum(salary),   -- Возвращает сумму числовых значений
       avg(salary),   -- Возвращает среднее значение
       max(salary),   -- Возвращает максимальное значение
       min(salary)    -- Возвращает минимальное значение
FROM employee;


---------------------------------------------------------------------------------------------------
---- ФУНКЦИИ ДЛЯ СТРОК ----------------------------------------------------------------------------
SELECT concat(first_name, ' ', last_name) имя_фамилия, -- Соединение значений нескольких полей
       upper(first_name),                              -- Привидение строки к верхнему регистру
       lower(last_name)                                -- Привидение строки к нижнему регистру
FROM employee;


---------------------------------------------------------------------------------------------------
---- UNION - ОБЪЕДИНЕИЕ ТАБЛИЦ --------------------------------------------------------------------

-- Выполняем первый запрос, получаем две записи с айди 6 и 7
-- Выполняем первый второй, получаем две записи с айди 8, 9, 10
-- Объединяем два запроса (количество и тип колонок должны совпадать)
-- UNION ALL - оставляет одинаковые комбинации значений в результате
-- UNION - убирает одинаковые комбинации значений из результата
SELECT first_name
from employee
WHERE id IN (1, 2)
UNION ALL
SELECT first_name
from employee
WHERE id IN (3, 4, 5);


---------------------------------------------------------------------------------------------------
---- ПОДЗАПРОСЫ ИЛИ ВЛОЖЕННЫЕ ЗАПРОСЫ -------------------------------------------------------------

-- ВАЖНО: Мы обязаны давать псевдонимы (Алиасы) нашим подзапросам при использовании FROM
-- Оператор SELECT можно использовать к таблицам, подзапросам и к другим множествам

-- Удаляем сотрудника, с самой большой зарплатой
DELETE
FROM employee
WHERE salary = (SELECT max(salary) FROM employee);

-- Получаем сумму зарплат двух сотрудников с самыми низкими зарплатами
SELECT sum(слабые_сотрудники.salary) сумма_зарплат
FROM (SELECT salary
      FROM employee
      ORDER BY salary
      LIMIT 2) слабые_сотрудники;

-- Выводим данные сотрудников, а так же самую большую и мальенькую зарплату в отдельных колонках
SELECT first_name,
       last_name,
       salary,
       (select min(salary) from employee),
       (select max(salary) from employee)
FROM employee;

-- Выбираем данные о сотрудниках, получаем название компании из другой таблицы
SELECT id,
       first_name                                       имя,
       last_name                                        фамилия,
       salary                                           зарплата,
       (select name from company where id = company_id) компания
FROM employee;


---------------------------------------------------------------------------------------------------
---- ПРАКТИКА №1: РЕШЕНИЕ ЗАДАЧ -------------------------------------------------------------------

--Создать таблицу "Автор"
DROP TABLE IF EXISTS author;
CREATE TABLE author
(
    id         SERIAL PRIMARY KEY,
    first_name VARCHAR(128) NOT NULL,
    last_name  VARCHAR(128) NOT NULL
);

--Создать таблицу "Книга"
DROP TABLE IF EXISTS book;
CREATE TABLE book
(
    id        BIGSERIAL PRIMARY KEY,
    name      VARCHAR(128) NOT NULL,
    year      SMALLINT     NOT NULL,
    pages     SMALLINT     NOT NULL,
    author_id INT REFERENCES author (id) ON DELETE CASCADE
);

--Заполнить таблицу "Автор"
INSERT INTO author (first_name, last_name)
VALUES ('Кей', 'Хорстманн'),
       ('Стивен', 'Кови'),
       ('Тони', 'Роббинс'),
       ('Наполеон', 'Хилл'),
       ('Роберт', 'Кийосаки'),
       ('Дейл', 'Карнеги');

--Заполнить таблицу "Книга"
INSERT INTO book (name, year, pages, author_id)
VALUES ('Java. Том 1', 2010, 1102, (SELECT id FROM author WHERE last_name = 'Хорстманн')),
       ('Java. Том 2', 2012, 954, (SELECT id FROM author WHERE last_name = 'Хорстманн')),
       ('Java. Том 3', 2015, 203, (SELECT id FROM author WHERE last_name = 'Хорстманн')),
       ('7 Навыков', 1989, 396, (SELECT id FROM author WHERE last_name = 'Кови')),
       ('Исполин', 1991, 576, (SELECT id FROM author WHERE last_name = 'Роббинс')),
       ('Думай, Богатей', 1937, 336, (SELECT id FROM author WHERE last_name = 'Хилл')),
       ('Богатый Папа', 1997, 352, (SELECT id FROM author WHERE last_name = 'Кийосаки')),
       ('Денежный Поток', 1998, 368, (SELECT id FROM author WHERE last_name = 'Кийосаки')),
       ('Живи Спокойно', 1948, 368, (SELECT id FROM author WHERE last_name = 'Карнеги')),
       ('Завоевать Друзей', 1936, 352, (SELECT id FROM author WHERE last_name = 'Карнеги'));

--Выбрать: название книги, год, имя и фамилию автора. Отсортировать по убыванию года издания
SELECT name                                                                    книга,
       year                                                                    год,
       concat((SELECT first_name FROM author WHERE author.id = book.author_id), ' ',
              (SELECT last_name FROM author WHERE author.id = book.author_id)) автор
FROM book
ORDER BY year DESC;

--Выбрать: количество книг у автора с фамилией 'Хорстманн'
SELECT count(name)
FROM book
WHERE author_id = (SELECT id FROM author WHERE last_name = 'Хорстманн');

--Выбрать: общее количество книг у авторов с фамилией 'Хорстманн' и 'Карнеги'
SELECT count(name)
FROM book
WHERE author_id IN ((SELECT id FROM author WHERE last_name = 'Хорстманн'),
                    (SELECT id FROM author WHERE last_name = 'Карнеги'));

--Выбрать: Книги, кол-во страниц которых, больше среднего кол-ва всех книг
SELECT *
FROM book
WHERE pages > (SELECT avg(pages) FROM book);

--Выбрать: 5 самых старых книг. Потом посчитать сумму всех страниц этих книг
SELECT id, name, year, pages
FROM book
ORDER BY year
LIMIT 5;

SELECT sum(oldest_books.pages)
FROM (SELECT pages
      FROM book
      ORDER BY year
      LIMIT 5) oldest_books;

--Изменить количество страниц у одной из книг. Вернуть все данные измененной книги.
UPDATE book
SET pages = 352
WHERE name = 'Завоевать Друзей'
RETURNING *;

--Выбрать автора, который написал самую большую книгу
SELECT last_name
FROM author
WHERE id = (SELECT author_id FROM book WHERE pages = (SELECT max(pages) FROM book));

--Удалить автора, который написал самую большую книгу. Вернуть этого данные автора
DELETE
FROM author
WHERE id = (SELECT author_id FROM book WHERE pages = (SELECT max(pages) FROM book))
RETURNING *;


---------------------------------------------------------------------------------------------------
---- JOIN - СОЕДИНЕНИЕ ТАБЛИЦ ---------------------------------------------------------------------

-- JOIN (INNER) - Получает набор только тех записей, у которых присутствует связь
-- CROSS JOIN
-- LEFT JOIN (OUTER) - Получает все записи из левой таблицы и связные записи из правой таблицы
-- RIGHT JOIN (OUTER) - Тоже самое что и "Левое соединение" только наоборот
-- FULL JOIN (OUTER) - Совокупность "Левого" и "Правого" соединений

--Соединяем две таблицы старым способом по условию WHERE (Получаем компании и их сотрудников)
SELECT company.name, employee.first_name || employee.last_name worker
FROM company,
     employee
WHERE company.id = employee.company_id;

--JOIN (INNER) Получаем сотрудников и все их номера, используя 3 таблицы
SELECT employee.first_name || employee.last_name worker,
       contact.number,
       contact.type
FROM employee
         JOIN employee_contact
              ON employee.id = employee_contact.employee_id
         JOIN contact
              ON employee_contact.contact_id = contact.id;

-- JOIN (INNER) Получаем только те компании, у которых есть работники
SELECT company.name, employee.first_name
FROM company
         JOIN employee ON employee.company_id = company.id;

-- LEFT JOIN (OUTER) Получаем все компании и их работников, если есть
SELECT company.name, employee.first_name
FROM company
         LEFT JOIN employee ON employee.company_id = company.id;

-- LEFT JOIN (OUTER) Получам всех работников и их компании, если есть
SELECT employee.first_name, company.name
FROM employee
         LEFT JOIN company ON company.id = employee.company_id;

-- FULL JOIN (OUTER) Получам все компании и работников, даже если они не связанны
SELECT company.name, employee.first_name
FROM company
         FULL JOIN employee ON employee.company_id = company.id;


---------------------------------------------------------------------------------------------------
---- ГРУППИРОВКИ (GROUP BY) и УСЛОВИЯ (HAVING)  ---------------------------------------------------

-- GROUP BY - Группирует значения колонок, когда мы агрегируем значения в других колонках
-- HAVING накладывает условие на сгруппированные записи. WHERE - на каждую запись до группировки

-- Таблица до группировки       Таблица после группировки
-- | Имя      | Выплаты |       | Имя       | Выплаты   |
-- | Петя     | 500     |       | Петя      | 2000      |
-- | Петя     | 1500    |       | Вася      | 5000      |
-- | Вася     | 2000    |
-- | Вася     | 3000    |


--Получаем количество сотрудников для каждой компании, кроме компании 'Google'
SELECT company.name, count(employee.id)
FROM company
         LEFT JOIN employee on company.id = company_id
GROUP BY company.name
HAVING count(employee.id) > 0;


---------------------------------------------------------------------------------------------------
---- ОКОННЫЕ ФУНКЦИИ (WINDOW FUNCTIONS) -----------------------------------------------------------

-- OVER () Добавляет новую колонку со значением агрегирующей функции, без использования GROUP BY
-- PARTITION BY - Используется для уточнения, среди каких значений использовать агрегатную функцию

-- Выводим Компанию, Сотрудника, ЗП, Максимальную зп в компании, Минимальную зп в компании
SELECT company.name                                          компания,
       employee.last_name                                    сотрудник,
       employee.salary                                       зп,
       max(employee.salary) OVER (PARTITION BY company.name) зп_макс,
       min(employee.salary) OVER (PARTITION BY company.name) зп_мин
FROM company
         LEFT JOIN employee on company.id = employee.company_id
ORDER BY company.name;


---------------------------------------------------------------------------------------------------
--- VIEW и MATERIALIZED VIEW - Переменная, в которую можно поместить запрос или результат запроса -

-- Помещаем запрос в переменную "employee_view"
CREATE VIEW employee_view AS
SELECT company.name                                          компания,
       employee.last_name                                    сотрудник,
       employee.salary                                       зп,
       max(employee.salary) OVER (PARTITION BY company.name) зп_макс,
       min(employee.salary) OVER (PARTITION BY company.name) зп_мин
FROM company
         LEFT JOIN employee on company.id = employee.company_id
ORDER BY company.name;

--Удаляем вью
DROP VIEW employee_view;

-- Используем запрос из переменной "employee_view"
SELECT *
FROM employee_view;

--------------------------------------------------------------------------

--Помещаем (кешируем) результат выполнения запроса в переменную "m_employee_view"
CREATE MATERIALIZED VIEW m_employee_view AS
SELECT company.name                                          компания,
       employee.last_name                                    сотрудник,
       employee.salary                                       зп,
       max(employee.salary) OVER (PARTITION BY company.name) зп_макс,
       min(employee.salary) OVER (PARTITION BY company.name) зп_мин
FROM company
         LEFT JOIN employee on company.id = employee.company_id
ORDER BY company.name;

--Обновляем закешированные данные в материализованной вью
REFRESH MATERIALIZED VIEW m_employee_view;

--Удаляем материализованное вью
DROP MATERIALIZED VIEW m_employee_view;

-- Используем закешированный результат запроса из переменной "m_employee_view"
SELECT *
FROM m_employee_view;


---------------------------------------------------------------------------------------------------
---- ALTER - ИЗМЕНЕНИЕ БАЗ ДАННЫХ, СХЕМ, ТАБЛИЦ ---------------------------------------------------

--Добавляем новую колонку
ALTER TABLE employee
    ADD COLUMN gender INT;

--Изменяем название колонки
ALTER TABLE employee
    RENAME gender TO sex;

--Заполняем значения новой колонки
update employee
set gender = 1
where id <= 5;
update employee
set gender = 0
where id > 5;

--Устанавливаем ограничение NOT NULL, т.к. мы не могли это сделать до заполнения колонок
ALTER TABLE employee
    ALTER COLUMN gender SET NOT NULL;

--Удаляем колонку из таблицы
ALTER TABLE employee
    DROP COLUMN gender;


---------------------------------------------------------------------------------------------------
---- ПРАКТИКА №2: РЕШЕНИЕ ЗАДАЧ -------------------------------------------------------------------

-- Создать базу данных перелетов Flights
-- Создать таблицы:
-- seat      (seat_no, aircraft_id)
-- aircraft  (id, model)
-- airport   (code, country, city)
-- ticket    (id, passenger_no, passenger_name, flight_id, seat_no, cost)
-- flight    (id, flight_no, departure_date, departure_airport_code,
--            arrival_date, arrival_airport_code, aircraft_id, status)

CREATE TABLE airport
(
    code    CHAR(3) PRIMARY KEY,
    country VARCHAR(256) NOT NULL,
    city    VARCHAR(128) NOT NULL
);

CREATE TABLE aircraft
(
    id    SERIAL PRIMARY KEY,
    model VARCHAR(128) NOT NULL
);

CREATE TABLE seat
(
    aircraft_id INT REFERENCES aircraft (id),
    seat_no     VARCHAR(4) NOT NULL,
    PRIMARY KEY (aircraft_id, seat_no)
);

CREATE TABLE flight
(
    id                     BIGSERIAL PRIMARY KEY,
    flight_no              VARCHAR(16)                       NOT NULL,
    departure_date         TIMESTAMP                         NOT NULL,
    departure_airport_code CHAR(3) REFERENCES airport (code) NOT NULL,
    arrival_date           TIMESTAMP                         NOT NULL,
    arrival_airport_code   CHAR(3) REFERENCES airport (code) NOT NULL,
    aircraft_id            INT REFERENCES aircraft (id)      NOT NULL,
    status                 VARCHAR(32)                       NOT NULL
);

CREATE TABLE ticket
(
    id             BIGSERIAL PRIMARY KEY,
    passenger_no   VARCHAR(32)                   NOT NULL,
    passenger_name VARCHAR(128)                  NOT NULL,
    flight_id      BIGINT REFERENCES flight (id) NOT NULL,
    seat_no        VARCHAR(4)                    NOT NULL,
    cost           NUMERIC(8, 2)                 NOT NULL
);

--Заполнить таблицы данными:

INSERT INTO airport (code, country, city)
VALUES ('MNK', 'Беларусь', 'Минск'),
       ('LDN', 'Англия', 'Лондон'),
       ('MSK', 'Россия', 'Москва'),
       ('BSL', 'Испания', 'Барселона');

INSERT INTO aircraft (model)
VALUES ('Боинг 777-300'),
       ('Боинг 737-300'),
       ('Аэробус A320-200'),
       ('Суперджет-100');

INSERT INTO seat (aircraft_id, seat_no)
SELECT id, s.column1
FROM aircraft
         CROSS JOIN (values ('A1'), ('A2'), ('B1'), ('B2'), ('C1'), ('C2'), ('D1'), ('D2') order by 1) s;

INSERT INTO flight (flight_no, departure_date, departure_airport_code, arrival_date,
                    arrival_airport_code, aircraft_id, status)
VALUES ('MN3002', '2020-06-14T14:30', 'MNK', '2020-06-14T18:07', 'LDN', 1, 'ARRIVED'),
       ('MN3002', '2020-06-16T09:15', 'LDN', '2020-06-16T13:00', 'MNK', 1, 'ARRIVED'),
       ('BC2801', '2020-07-28T23:25', 'MNK', '2020-07-29T02:43', 'LDN', 2, 'ARRIVED'),
       ('BC2801', '2020-08-01T11:00', 'LDN', '2020-08-01T14:15', 'MNK', 2, 'DEPARTED'),
       ('TR3103', '2020-05-03T13:10', 'MSK', '2020-05-03T18:38', 'BSL', 3, 'ARRIVED'),
       ('TR3103', '2020-05-10T07:15', 'BSL', '2020-05-10T12:44', 'MSK', 3, 'CANCELLED'),
       ('CV9827', '2020-09-09T18:00', 'MNK', '2020-09-09T19:15', 'MSK', 4, 'SCHEDULED'),
       ('CV9827', '2020-09-19T08:55', 'MSK', '2020-09-19T10:05', 'MNK', 4, 'SCHEDULED'),
       ('QS8712', '2020-12-18T03:35', 'MNK', '2020-12-18T06:46', 'LDN', 2, 'ARRIVED');

INSERT INTO ticket (passenger_no, passenger_name, flight_id, seat_no, cost)
VALUES ('112233', 'Иван Иванов', 1, 'A1', 200),
       ('23234A', 'Петр Петров', 1, 'B1', 180),
       ('SS988D', 'Светлана Светикова', 1, 'B2', 175),
       ('QYASDE', 'Андрей Андреев', 1, 'C2', 175),
       ('POQ234', 'Иван Кожемякин', 1, 'D1', 160),
       ('898123', 'Олег Рубцов', 1, 'A2', 198),
       ('555321', 'Екатерина Петренко', 2, 'A1', 250),
       ('QO23OO', 'Иван Розмаринов', 2, 'B2', 225),
       ('9883IO', 'Иван Кожемякин', 2, 'C1', 217),
       ('123UI2', 'Андрей Буйнов', 2, 'C2', 227),
       ('SS988D', 'Светлана Светикова', 2, 'D2', 277),
       ('EE2344', 'Дмитрий Трусцов', 3, 'А1', 300),
       ('AS23PP', 'Максим Комсомольцев', 3, 'А2', 285),
       ('322349', 'Эдуард Щеглов', 3, 'B1', 99),
       ('DL123S', 'Игорь Беркутов', 3, 'B2', 199),
       ('MVM111', 'Алексей Щербин', 3, 'C1', 299),
       ('ZZZ111', 'Денис Колобков', 3, 'C2', 230),
       ('234444', 'Иван Старовойтов', 3, 'D1', 180),
       ('LLLL12', 'Людмила Старовойтова', 3, 'D2', 224),
       ('RT34TR', 'Степан Дор', 4, 'A1', 129),
       ('999666', 'Анастасия Шепелева', 4, 'A2', 152),
       ('234444', 'Иван Старовойтов', 4, 'B1', 140),
       ('LLLL12', 'Людмила Старовойтова', 4, 'B2', 140),
       ('LLLL12', 'Роман Дронов', 4, 'D2', 109),
       ('112233', 'Иван Иванов', 5, 'С2', 170),
       ('NMNBV2', 'Лариса Тельникова', 5, 'С1', 185),
       ('DSA586', 'Лариса Привольная', 5, 'A1', 204),
       ('DSA583', 'Артур Мирный', 5, 'B1', 189),
       ('DSA581', 'Евгений Кудрявцев', 6, 'A1', 204),
       ('EE2344', 'Дмитрий Трусцов', 6, 'A2', 214),
       ('AS23PP', 'Максим Комсомольцев', 6, 'B2', 176),
       ('112233', 'Иван Иванов', 6, 'B1', 135),
       ('309623', 'Татьяна Крот', 6, 'С1', 155),
       ('319623', 'Юрий Дувинков', 6, 'D1', 125),
       ('322349', 'Эдуард Щеглов', 7, 'A1', 69),
       ('DIOPSL', 'Евгений Безфамильная', 7, 'A2', 58),
       ('DIOPS1', 'Константин Швец', 7, 'D1', 65),
       ('DIOPS2', 'Юлия Швец', 7, 'D2', 65),
       ('1IOPS2', 'Ник Говриленко', 7, 'C2', 73),
       ('999666', 'Анастасия Шепелева', 7, 'B1', 66),
       ('23234A', 'Петр Петров', 7, 'C1', 80),
       ('QYASDE', 'Андрей Андреев', 8, 'A1', 100),
       ('1QAZD2', 'Лариса Потемнкина', 8, 'A2', 89),
       ('5QAZD2', 'Карл Хмелев', 8, 'B2', 79),
       ('2QAZD2', 'Жанна Хмелева', 8, 'С2', 77),
       ('BMXND1', 'Светлана Хмурая', 8, 'В2', 94),
       ('BMXND2', 'Кирилл Сарычев', 8, 'D1', 81),
       ('SS988D', 'Светлана Светикова', 9, 'A2', 222),
       ('SS978D', 'Андрей Желудь', 9, 'A1', 198),
       ('SS968D', 'Дмитрий Воснецов', 9, 'B1', 243),
       ('SS958D', 'Максим Гребцов', 9, 'С1', 251),
       ('112233', 'Иван Иванов', 9, 'С2', 135),
       ('NMNBV2', 'Лариса Тельникова', 9, 'B2', 217),
       ('23234A', 'Петр Петров', 9, 'D1', 189),
       ('123951', 'Полина Зверева', 9, 'D2', 234);


-- Получаем позавчерашнюю дату, приводим ее к типу "date" отсекая секунды
SELECT (now() - interval '2 days')::date;

-- 1. Кто летел позавчера('2020-12-18') рейсом Минск (MNK) - Лондон(LDN) на месте B1 ?
SELECT ticket.passenger_name,
       ticket.seat_no,

       flight.departure_date::date,
       flight.departure_airport_code,
       flight.arrival_airport_code
FROM ticket
         JOIN flight on flight.id = ticket.flight_id
WHERE ticket.seat_no = 'B1'
  AND flight.departure_airport_code = 'MNK'
  AND flight.arrival_airport_code = 'LDN'
  AND flight.departure_date::date = '2020-12-18';


-- 2. Сколько мест осталось незанятыми 2020-06-14 на рейсе MN3002?
select t2.count - t1.count
from (select f.aircraft_id, count(*)
      from ticket t
               join flight f
                    on f.id = t.flight_id
      where f.flight_no = 'MN3002'
        and f.departure_date::date = '2020-06-14'
      group by f.aircraft_id) t1
         join (select aircraft_id, count(*)
               from seat
               group by aircraft_id) t2
              on t1.aircraft_id = t2.aircraft_id;

SELECT EXISTS(select 1 from ticket where id = 2000);

-- Какие именно места не были заняты?
select s.seat_no
from seat s
where aircraft_id = 1
  and not exists(select t.seat_no
                 from ticket t
                          join flight f
                               on f.id = t.flight_id
                 where f.flight_no = 'MN3002'
                   and f.departure_date::date = '2020-06-14'
                   and s.seat_no = t.seat_no);

-- 3 variant
select aircraft_id, s.seat_no
from seat s
where aircraft_id = 1
except
select f.aircraft_id, t.seat_no
from ticket t
         join flight f
              on f.id = t.flight_id
where f.flight_no = 'MN3002'
  and f.departure_date::date = '2020-06-14';


-- 3. Какие 2 перелета были самые длительные за все время?
SELECT flight_no, (arrival_date - departure_date) длительность
FROM flight
ORDER BY длительность DESC
LIMIT 2;

-- 4. Какая макс и мин длительность перелетов между Минском и Лондоном. Сколько было всего таких перелетов?
SELECT flight_no,
       d.city,
       a.city,
       count(flight.flight_no) OVER (),
       min(arrival_date - departure_date) OVER (),
       max(arrival_date - departure_date) OVER ()
FROM flight
         JOIN airport d ON flight.departure_airport_code = d.code
         JOIN airport a ON flight.arrival_airport_code = a.code
WHERE d.city = 'Минск'
  AND a.city = 'Лондон';

-- 5. Какие имена встречаются чаще всего и какую долю от числа всех пассажиров они составляют? Возвр. имя (параметры)
select t.passenger_name,
       count(*),
       round(100.0 * count(*) / (select count(*) from ticket), 2)
from ticket t
group by t.passenger_name
order by 2 desc;

-- 6. Вывести имена пассажиров, сколько всего каждый с таким именем купил билетов,
-- а также на сколько это количество меньше от того имени пассажира, кто купил билетов больше всего
select t1.*,
       first_value(t1.cnt) over () - t1.cnt
from (select t.passenger_no,
             t.passenger_name,
             count(*) cnt
      from ticket t
      group by t.passenger_no, t.passenger_name
      order by 3 desc) t1;

-- 7. Вывести стоимость всех маршрутов по убыванию.
-- Отобразить разницу в стоимости между текущим и ближайшими в отсортированном списке маршрутами

select t1.*,
       COALESCE(lead(t1.sum_cost) OVER (order by t1.sum_cost), t1.sum_cost) - t1.sum_cost
from (select t.flight_id,
             sum(t.cost) sum_cost
      from ticket t
      group by t.flight_id
      order by 2 desc) t1;


---------------------------------------------------------------------------------------------------
---- ТЕОРИЯ МНОЖЕСТВ ------------------------------------------------------------------------------

--Объединяем два множества, убирая одинаковые комбинации записей (строк)
VALUES (1, 'Петр', 'Петров'),
       (2, 'Семен', 'Семенов'),
       (3, 'Василий', 'Васильев')
UNION
VALUES (3, 'Василий', 'Васильев'),
       (4, 'Сергей', 'Сергеев'),
       (5, 'Владимир', 'Владимиров')
ORDER BY column1;

--Объединяем два множества, даже если будут дублироваться комбинации записей (строк)
VALUES (1, 'Петр', 'Петров'),
       (2, 'Семен', 'Семенов'),
       (3, 'Василий', 'Васильев')
UNION ALL
VALUES (3, 'Василий', 'Васильев'),
       (4, 'Сергей', 'Сергеев'),
       (5, 'Владимир', 'Владимиров')
ORDER BY column1;

--Получаем только те строки из первого множества, которых нет во втором множестве
VALUES (1, 'Петр', 'Петров'),
       (2, 'Семен', 'Семенов'),
       (3, 'Василий', 'Васильев')
EXCEPT
VALUES (3, 'Василий', 'Васильев'),
       (4, 'Сергей', 'Сергеев'),
       (5, 'Владимир', 'Владимиров')
ORDER BY column1;

--Получаем только те строки, которые есть в двух множествах одновременно
VALUES (1, 'Петр', 'Петров'),
       (2, 'Семен', 'Семенов'),
       (3, 'Василий', 'Васильев')
INTERSECT
VALUES (3, 'Василий', 'Васильев'),
       (4, 'Сергей', 'Сергеев'),
       (5, 'Владимир', 'Владимиров')
ORDER BY column1;


---------------------------------------------------------------------------------------------------
---- ИНДЕКСЫ - Отдельные файлы, хранящие значения полей и ссылки на строки таблиц в БД ------------

-- B-Tree Index - Древовидная структура данных, способствующая быстрому поиску элементов.
-- Не нужно создавать индексы для всех полей. CRUD операции становятся затратнее по ресурсам.

-- Селективность поля - Показатель наличия уникальных значений поля. Чем выше, тем лучше.
-- Расчитывается по формуле: Селективность = Кол-во уникальных значений / Кол-во всех значений.
-- Не имеет смысла создавать индекс на поле с низкой селективностью 0.1 - 0.5

-- Селективность поля 'id' равна 1 (Наилучшая селективность)
SELECT count(DISTINCT id) / (SELECT count(id) FROM employee)
FROM employee;

-- Селективность поля 'id' равна 0.9 (Хорошая селективность)
SELECT count(DISTINCT first_name) / (SELECT count(first_name) FROM employee)
FROM employee;

-- (ИНДЕКС РАБОТАЕТ) Выполняем поиск по полям составного индекса "first_name" + "last_name"
SELECT *
FROM employee
WHERE first_name = 'Ivan'
  AND last_name = 'Ivanov';

-- (ИНДЕКС РАБОТАЕТ) Выполняем поиск по первому полю составного индекса "first_name"
SELECT *
FROM employee
WHERE first_name = 'Ivan';

-- (ИНДЕКС НЕ РАБОТАЕТ) Выполняем поиск по второму полю составного индекса "last_name"
SELECT *
FROM employee
WHERE last_name = 'Ivanov';


---------------------------------------------------------------------------------------------------
---- ПЛАН ВЫПОЛНЕНИЯ ЗАПРОСОВ - ОСНОВЫ ------------------------------------------------------------

-- Виды оптимизаторов:
-- Синтаксический (rule-based) - Устаревший и малоэффективный. Основывался на синтаксисе запроса.
-- Стоимостной (cost-based) - Современный, эффективный. Основывается на стоимости запроса.

-- Виды индексных сканирований:
-- 1. Index only scan - сразу возвращает искомое значение, не обращаясь к таблице
-- 2. Index scan - обращается за данными к таблице используя ссылки
-- 3. Bitmap scan - состоит из двух частей: index scan, heap scan
-- 3.1 Bitmap index scan - сканирует индекс и определяет какие страницы нужны для считывания
-- 3.2 Bitmap index heap - считывает данные с таблицы делая проверку на искомые элементы

-- Результат выполнения запроса: Seq Scan on employee  (cost=0.00..11.30 rows=130 width=564)
-- Seq Scan on employee - означает полное сканирование таблицы "employee"
-- cost=0.00..11.30 - означает стоимость запроса
-- rows=130 - означет предполагаемое количество возвращаемых строк
-- width=564 - означает средний вес одной строчки в байтах

-- Как происходит расчет стоимости запроса:
-- Page_cost - Каждая считанная страница (сегмент жесткого диска) добавляет 1.0 к стоимости
-- Cpu_cost - Каждая строка (запись) добавляет 0.01 к стоимости

-- Расчитываем среднее кол-во байт, занимаемых каждой строчкой в таблице "employee"
SELECT avg(bit_length(employee.id::text) / 8)         AS id,
       avg(bit_length(employee.first_name) / 8)       AS first_name,
       avg(bit_length(employee.last_name) / 8)        AS last_name,
       avg(bit_length(employee.salary::text) / 8)     AS salary,
       avg(bit_length(employee.company_id::text) / 8) AS company_id
FROM employee;

-- Обновляем статистику о таблице 'employee'
analyse employee;
-- Получаем информацию о таблице 'employee'
SELECT relname, reltuples, relkind, relpages
FROM pg_class
WHERE relname LIKE 'employee%';

-- Получаем план запроса (фулл скан)
EXPLAIN
SELECT *
FROM employee;

-- Получаем план запроса (фулл скан с фильтрацией)
EXPLAIN
SELECT *
FROM employee
WHERE employee.last_name LIKE 'I%';

-- Получаем план запроса (фулл скан с группировкой)
EXPLAIN
SELECT first_name
FROM employee
GROUP BY first_name;


---------------------------------------------------------------------------------------------------
---- ПЛАН ВЫПОЛНЕНИЯ ЗАПРОСОВ - ИНДЕКСЫ -----------------------------------------------------------

-- Создаем тестовую таблицу
DROP TABLE test1;
CREATE TABLE test1
(
    id      SERIAL PRIMARY KEY,
    number1 INT         NOT NULL,
    number2 INT         NOT NULL,
    value   VARCHAR(32) NOT NULL
);

-- Заполняем в тестовую таблицу 100000 записей
INSERT INTO test1 (number1, number2, value)
SELECT random() * generate_series,
       random() * generate_series,
       generate_series
FROM generate_series(1, 100000);

-- Создаем два индекса для двух полей
CREATE INDEX test1_number1_idx ON test1 (number1);
CREATE INDEX test1_number2_idx ON test1 (number2);

-- Обновляем статистику о таблице 'employee'
analyse test1;
-- Получаем информацию о таблице 'test'
SELECT relname, reltuples, relkind, relpages
FROM pg_class
WHERE relname LIKE 'test1%';

-- Получаем план запроса (индекс онли скан)
EXPLAIN
SELECT number1
FROM test1
WHERE number1 = 1000;

-- Получаем план запроса (индекс скан)
EXPLAIN
SELECT *
FROM test1
WHERE number1 = 1000;

-- Получаем план запроса (битмэп скан)
EXPLAIN
SELECT *
FROM test1
WHERE number1 < 1000
  AND number1 > 90000;

-- Получаем план запроса (двойной битмэп скан по двум индексам)
EXPLAIN
SELECT *
FROM test1
WHERE number1 < 1000
   OR number2 > 90000;

-- Пример плохого запроса - оператор OR заставил сделать фулл скан (плохая производительность)
EXPLAIN
SELECT *
FROM test1
WHERE number1 = 1000
   OR value = '12345';


---------------------------------------------------------------------------------------------------
---- ПЛАН ВЫПОЛНЕНИЯ ЗАПРОСОВ - СОЕДИНЕНИЯ (JOINS) ------------------------------------------------

-- Варианты связывания таблиц:
-- 1. Nested Loop - Используется при малом количестве результирующих записей (связывает циклом)
-- 2. Hash Join - Используется при большом количестве результирующих записей (создает хеш таблицу)
-- 3. Merge Join - Используется при связывании отсортированных таблиц (цикл по двум таблицам)

-- Создаем вторую тестовую таблицу с дополительным полем внешнего ключа
DROP TABLE test2;
CREATE TABLE test2
(
    id       SERIAL PRIMARY KEY,
    test1_id INT REFERENCES test1 (id) NOT NULL,
    number1  INT                       NOT NULL,
    number2  INT                       NOT NULL,
    value    VARCHAR(32)               NOT NULL
);

-- Заполняем вторую тестовую таблицу
INSERT INTO test2 (test1_id, number1, number2, value)
SELECT id, random() * number1, random() * number2, value
FROM test1;

-- Создаем три индекса для трех полей
CREATE INDEX test2_number1_idx ON test2 (number1);
CREATE INDEX test2_number2_idx ON test2 (number2);
CREATE INDEX test2_test1_id_idx ON test2 (test1_id);

-- План запроса (Индекс скан test1 | Фулл скан test2 | Связывание Нестед луп)
EXPLAIN ANALYSE
SELECT * FROM test1
JOIN test2 on test1.id = test2.test1_id
LIMIT 100;

-- План запроса (Фулл скан test1 | Создание Хеш таблицы | Фулл скан test2 | Связывание Хеш Джоин)
EXPLAIN ANALYSE
SELECT * FROM test1
JOIN test2 on test1.id = test2.test1_id;

-- План запроса (Индекс скан test1 | Фулл скан test2 | Связывание Мердж Джоин)
EXPLAIN ANALYSE
SELECT * FROM test1
JOIN (SELECT * FROM test2 ORDER BY test1_id) test2 on test1.id = test2.test1_id;


---------------------------------------------------------------------------------------------------
---- ТРАНЗАКЦИИ И БЛОКИРОВКИ ----------------------------------------------------------------------

-- ТРАНЗАКЦИЯ это - набор операций, которые выполняются полностью, либо ни одна.

-- ACID Свойства транзакций:
-- Atomicity (Атомарность)       - Гарантирует выполнение набора операций полностью, либо ни одной
-- Consistency (Согласованность) - Фиксация только допустимых данных, разрешенных ограничениями
-- Isolation (Изоляция)          - Паралельные транзакции не должны оказывать влияние друг на друга
-- Durability (Устойчивость)     - После успешного завершения транзакции, данные должны сохраниться


-- ПРОБЛЕМЫ ИЗОЛЯЦИИ ТРАНЗАКЦИЙ (Transaction isolation issues):

-- 1. Lost Update (Потерянное обновление) - Когда обе транзакции обновляют данные, затем вторая
-- транзакция откатывает изменения, в результате чего теряются изменения обеих транзакций.

-- 2. Dirty Read (Грязное чтение) - Когда первая транзакция читает изменения, сделанные второй
-- транзакцией, но эти изменения еще не зафиксированны, после чего вторая транзакция откатывает
-- изменения, а первая транзакция продолжает работу с неактуальными(грязными) данными.

-- 3. Non Repeatable Read (Неповторяющееся чтение) - Когда первая транзакция читает одни и те же
-- данные дважды, но после первого чтения вторая транзакция изменяет и фиксирует эти данные,
-- в результате вторая операция чтения первой транзакции вернет уже другой результат.

-- 3.1 Last Commit Wins (Особый случай Non Repeatable Read) - Когда обе транзакции читают
-- одинаковые данные, первая транзакция успевает изменить их раньше второй транзакции,
-- в результате фиксация данных первой транзакции затирается данными второй транзакции.

-- 4. Phantom Read (Фантомное чтение) - Когда первая транзакция читает один набор данных дважды
-- но после первого чтения, вторая транзакция добавляет новые строки или удаляет старые,
-- в результате второе чтение первой транзакции вернет уже другое кол-во строк данных.

-- УРОВНИ ИЗОЛИРОВАННОСТИ ТРАНЗАКЦИЙ:
-- 1. READ UNCOMMITTED - Решает проблему: Lost Update
-- 2. READ COMMITTED - Решает проблемы: Lost Update, Dirty Read
-- 3. REPEATABLE READ - Решает проблемы: Lost Update, Dirty Read, Non Repeatable Read
-- 4. SERIALIZABLE - Решает проблемы: Lost Update, Dirty Read, Non Repeatable Read, Phantom Read


---------------------------------------------------------------------------------------------------
---- ТРИГГЕРЫ -------------------------------------------------------------------------------------

--- before

insert into aircraft (model)
values ('new boeing');

--- after


create table audit
(
    id INT,
    table_name TEXT,
    date TIMESTAMP
);

create or replace function audit_function() returns trigger
              language plpgsql
              AS $$
begin
insert into audit (id, table_name, date)
values (new.id, tg_table_name, now());
return null;
end;
$$;

create trigger audit_aircraft_trigger
    AFTER UPDATE OR INSERT OR DELETE
    ON aircraft
    FOR EACH ROW
EXECUTE FUNCTION audit_function();

insert into aircraft (model)
values ('новый боинг');

select *
from audit;