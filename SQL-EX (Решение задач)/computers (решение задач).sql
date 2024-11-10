----РЕШЕНИЕ ЗАДАЧ----------------------------------------------------------------------------------


-- 1. Найдите номер модели, скорость и размер жесткого диска для всех ПК стоимостью менее 500 доларов
-- Вывести: model, speed и hd

SELECT PC.model, PC.speed, PC.hd
FROM PC
WHERE price < 500;

-- 2. Найдите производителей принтеров. Вывести: maker
SELECT DISTINCT maker
FROM product
WHERE type = 'Printer';

-- 3. Найдите номер модели, объем памяти и размеры экранов ПК-блокнотов, цена которых превышает 1000 дол.
SELECT model, ram, screen
FROM laptop
WHERE price > 1000;

-- 4. Найдите все записи таблицы Printer для цветных принтеров.
SELECT *
FROM printer
WHERE color = 'y';

-- 5. Найдите номер модели, скорость и размер жесткого диска ПК, имеющих 12x или 24x CD и цену менее 600 дол.
SELECT model, speed, hd
FROM PC
WHERE (cd = '12x' OR cd = '24x')
  AND price < 600;

-- 6. Для каждого производителя, выпускающего ПК-блокноты c объёмом жесткого диска не менее 10 Гбайт,
-- найти скорости таких ПК-блокнотов. Вывод: производитель, скорость.

SELECT DISTINCT Product.maker, Laptop.speed
FROM Product
         JOIN Laptop ON Product.model = Laptop.model
WHERE Laptop.hd >= 10;

-- 7. Найдите номера моделей и цены всех имеющихся в продаже продуктов (любого типа) производителя B (латинская буква).
SELECT Product.model, Laptop.price
FROM Product
         JOIN Laptop on Product.model = Laptop.model
WHERE Product.maker = 'B'

UNION

SELECT Product.model, PC.price
FROM product
         JOIN PC ON Product.model = PC.model
WHERE Product.maker = 'B'

UNION

SELECT Product.model, Printer.price
FROM product
         JOIN Printer ON Product.model = Printer.model
WHERE Product.maker = 'B';

-- 8. Найдите производителя, выпускающего ПК, но не ПК-блокноты.
SELECT DISTINCT maker
FROM Product
WHERE type = 'PC'
  AND maker NOT IN (SELECT DISTINCT maker FROM Product WHERE type = 'Laptop');

-- 9. Найдите производителей ПК с процессором не менее 450 Мгц. Вывести: Maker
SELECT DISTINCT maker
FROM Product
         JOIN PC on Product.model = PC.model
WHERE PC.speed >= 450;

-- 10. Найдите модели принтеров, имеющих самую высокую цену. Вывести: model, price
SELECT DISTINCT model, price
FROM Printer
WHERE price = (SELECT max(price) FROM Printer);

-- 11. Найдите среднюю скорость ПК.
SELECT avg(speed)
FROM PC;

-- 12. Найдите среднюю скорость ПК-блокнотов, цена которых превышает 1000 дол.
SELECT avg(speed)
FROM Laptop
WHERE price > 1000;

-- 13. Найдите среднюю скорость ПК, выпущенных производителем A.
SELECT avg(speed)
FROM PC
         JOIN Product on PC.model = Product.model
WHERE Product.maker = 'A';

-- 15. Найдите размеры жестких дисков, совпадающих у двух и более PC. Вывести: HD
SELECT hd
FROM pc
GROUP BY (hd)
HAVING COUNT(model) >= 2;

-- 16. Найдите пары моделей PC, имеющих одинаковые скорость и RAM.
-- В результате каждая пара указывается только один раз, т.е. (i,j), но не (j,i),
-- Порядок вывода: модель с большим номером, модель с меньшим номером, скорость и RAM.

SELECT DISTINCT p1.model, p2.model, p1.speed, p1.ram
FROM pc p1,
     pc p2
WHERE p1.speed = p2.speed
  AND p1.ram = p2.ram
  AND p1.model > p2.model;

-- 17. Найдите модели ПК-блокнотов, скорость которых меньше скорости каждого из ПК.
-- Вывести: type, model, speed

SELECT DISTINCT Product.type, Laptop.model, Laptop.speed
FROM Laptop
         JOIN Product on Laptop.model = Product.model
WHERE Laptop.speed < (SELECT min(PC.speed) FROM PC);

-- 18. Найдите производителей самых дешевых цветных принтеров. Вывести: maker, price

SELECT DISTINCT product.maker, printer.price
FROM product,
     printer
WHERE product.model = printer.model
  AND printer.color = 'y'
  AND printer.price = (SELECT MIN(price)
                       FROM printer
                       WHERE printer.color = 'y');

SELECT DISTINCT product.maker, printer.price
FROM product
         JOIN printer ON product.model = printer.model
WHERE printer.color = 'y'
  AND printer.price = (SELECT min(price) FROM Printer WHERE printer.color = 'y');

-- 19. Для каждого производителя, имеющего модели в таблице Laptop,
-- найдите средний размер экрана выпускаемых им ПК-блокнотов.
-- Вывести: maker, средний размер экрана.

SELECT product.maker, avg(laptop.screen)
FROM product
         JOIN Laptop on product.model = Laptop.model
GROUP BY product.maker;

-- 20. Найдите производителей, выпускающих по меньшей мере три различных модели ПК. Вывести: Maker, число моделей ПК.

SELECT maker, COUNT(model)
FROM product
WHERE type = 'PC'
GROUP BY product.maker
HAVING COUNT (DISTINCT model) >= 3;