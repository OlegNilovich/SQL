---- РЕШЕНИЕ ЗАДАЧ --------------------------------------------------------------------------------

-- 14. Найдите класс, имя и страну для кораблей из таблицы Ships, имеющих не менее 10 орудий.
SELECT ships.class, ships.name, classes.country
FROM ships JOIN classes ON ships.class = classes.class
WHERE classes.numGuns >= 10;