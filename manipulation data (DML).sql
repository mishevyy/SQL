/*----------------------------Работа с данными------------------------------------------------------*/
/*
DML (Data Manipulation Language / Язык манипуляции данными). 
К этому типу относят команды на выбору данных, их обновление, добавление, удаление.
SELECT: извлекает данные из БД
UPDATE: обновляет данные
INSERT: добавляет новые данные
DELETE: удаляет данные
*/

/*--------------------------------------------------------------------------------------------------*/
/*----------------------------Обработка данных------------------------------------------------------*/

-- Добавление данных
-- INSERT [INTO] имя_таблицы [(список_столбцов)] VALUES (значение1, значение2, ... значениеN)
INSERT INTO Products (ProductName, Price, Manufacturer) 
VALUES ('iPhone 6S', 41000, 'Apple')

-- Обновление данных
-- UPDATE имя_таблицы
-- SET столбец1 = значение1, столбец2 = значение2, ... столбецN = значениеN
-- [FROM выборка AS псевдоним_выборки]
-- [WHERE условие_обновления]
UPDATE Products
SET Price = Price + 5000

-- Удаление данных
-- DELETE [FROM] имя_таблицы
-- WHERE условие_удаления
DELETE Products
WHERE Id=9


/*--------------------------------------------------------------------------------------------------*/
/*----------------------------Получение данных------------------------------------------------------*/

-- SELECT список_столбцов FROM имя_таблицы
SELECT * FROM Products
SELECT ProductName, Price FROM Products
SELECT ProductName + ' (' + Manufacturer + ')', Price, Price * ProductCount 
FROM Products

-- AS - новое имя для столюца
SELECT
ProductName + ' (' + Manufacturer + ')' AS ModelName, 
Price,  
Price * ProductCount AS TotalSum
FROM Products

-- DISTINCT - уникальные значения
SELECT DISTINCT Manufacturer
FROM Products
 
-- INTO вставка результата во временную таблицу
SELECT ProductName + ' (' + Manufacturer + ')' AS ModelName, Price
INTO ProductSummary
FROM Products 
SELECT * FROM ProductSummary


/*--------------------------------------------------------------------------------------------------*/
/*----------------------------Сортировка данных-----------------------------------------------------*/

-- ORDER BY - сортировка
SELECT *
FROM Products
ORDER BY ProductName
-- ORDER BY DESC - сортировка в обратном порядке
SELECT ProductName
FROM Products
ORDER BY ProductName DESC

-- Извлечение диапазона строк
-- Оператор TOP
SELECT TOP 4 ProductName
FROM Products

-- PERCENT - позволяет выбрать процентное количество строк
SELECT TOP 75 PERCENT ProductName
FROM Products

-- OFFSET и FETCH - выбор диапазона значений (только в отсартированном наборе)
-- ORDER BY выражение 
--     OFFSET смещение_относительно_начала {ROW|ROWS}
--     [FETCH {FIRST|NEXT} количество_извлекаемых_строк {ROW|ROWS} ONLY]

-- Число после ключевого слова OFFSET указывает, сколько строк необходимо пропустить.
SELECT * FROM Products
ORDER BY Id 
    OFFSET 2 ROWS;

-- После оператора FETCH указывается ключевое слово FIRST или NEXT 
-- (какое именно в данном случае не имеет значения) и затем указывается количество строк, которое надо получить.
SELECT * FROM Products
ORDER BY Id 
    OFFSET 2 ROWS
    FETCH NEXT 3 ROWS ONLY;   


/*--------------------------------------------------------------------------------------------------*/
/*----------------------------Фильтрация данных------------------------------------------------------*/

-- Фильтрация. WHERE
-- WHERE условие
-- =: сравнение на равенство (в отличие от си-подобных языков в T-SQL для сравнения на равенство используется один знак равно)
-- <>: сравнение на неравенство
-- <: меньше чем
-- >: больше чем
-- !<: не меньше чем
-- !>: не больше чем
-- <=: меньше чем или равно
-- >=: больше чем или равно   

-- Логические операторы : AND / OR /  NOT
-- Проверка на NULL: IS NULL / IS NOT NULL

-- Операторы фильтрации IN
-- WHERE выражение [NOT] IN (выражение)
SELECT * FROM Products
WHERE Manufacturer IN ('Samsung', 'Xiaomi', 'Huawei')

-- Оператор BETWEEN - пределяет диапазон значений с помощью начального и конечного значения, которому должно соответствовать выражение
-- WHERE выражение [NOT] BETWEEN начальное_значение AND конечное_значение
SELECT * FROM Products
WHERE Price BETWEEN 20000 AND 40000

-- Оператор LIKE - принимает шаблон строки, которому должно соответствовать выражение
-- WHERE выражение [NOT] LIKE шаблон_строк
-- %: соответствует любой подстроке, которая может иметь любое количество символов, при этом подстрока может и не содержать ни одного символа
-- _: соответствует любому одиночному символу
-- [ ]: соответствует одному символу, который указан в квадратных скобках
-- [ - ]: соответствует одному символу из определенного диапазона
-- [ ^ ]: соответствует одному символу, который не указан после символа ^
SELECT * FROM Products
WHERE ProductName LIKE 'iPhone [6-8]%'


/*--------------------------------------------------------------------------------------------------*/
/*----------------------------Группировка данных----------------------------------------------------*/

-- Агрегатные функции
-- AVG: находит среднее значение
-- SUM: находит сумму значений
-- MIN: находит наименьшее значение
-- MAX: находит наибольшее значение
-- COUNT: находит количество строк в запросе
SELECT AVG(Price) AS Average_Price FROM Products
SELECT COUNT(*) FROM Products
SELECT COUNT(Manufacturer) FROM Products
SELECT MIN(Price) FROM Products
SELECT MAX(Price) FROM Products
SELECT SUM(ProductCount) FROM Products

-- All и Distinct По умолчанию все вышеперечисленных пять функций учитывают все строки
-- Если необходимо выполнить вычисления только над уникальными значениями , то для этого применяется оператор DISTINCT
SELECT AVG(DISTINCT ProductCount) AS Average_Price FROM Products

-- Операторы GROUP BY и HAVING
-- SELECT столбцы
-- FROM таблица
-- [WHERE условие_фильтрации_строк]
-- [GROUP BY столбцы_для_группировки]
-- [HAVING условие_фильтрации_групп]
-- [ORDER BY столбцы_для_сортировки]

-- GROUP BY определяет, как строки будут группироваться.
SELECT Manufacturer, COUNT(*) AS ModelsCount
FROM Products
GROUP BY Manufacturer

-- Фильтрация групп. HAVING
SELECT Manufacturer, COUNT(*) AS ModelsCount
FROM Products
GROUP BY Manufacturer
HAVING COUNT(*) > 1

-- Дополнительно к стандартным операторам GROUP BY и HAVING SQL Server поддерживает 
-- еще четыре специальных расширения для группировки данных: ROLLUP, CUBE, GROUPING SETS и OVER.

-- ROLLUP
-- Оператор ROLLUP добавляет суммирующую строку в результирующий набор:
-- При группировке по нескольким критериям ROLLUP будет создавать суммирующую строку для каждой из подгрупп:
SELECT Manufacturer, COUNT(*) AS Models, SUM(ProductCount) AS Units
FROM Products
GROUP BY Manufacturer WITH ROLLUP

-- CUBE
-- CUBE похож на ROLLUP за тем исключением, что CUBE добавляет суммирующие строки для каждой комбинации групп.
SELECT Manufacturer, COUNT(*) AS Models, SUM(ProductCount) AS Units
FROM Products
GROUP BY Manufacturer, ProductCount WITH CUBE

-- GROUPING SETS
-- Оператор GROUPING SETS аналогично ROLLUP и CUBE добавляет суммирующую строку для групп. 
-- Но при этом он не включает сами группам:
SELECT Manufacturer, COUNT(*) AS Models, ProductCount
FROM Products
GROUP BY GROUPING SETS(Manufacturer, ProductCount)
-- можно комбинировать с ROLLUP или CUBE
SELECT Manufacturer, COUNT(*) AS Models, 
        ProductCount, SUM(ProductCount) AS Units
FROM Products
GROUP BY GROUPING SETS(ROLLUP(Manufacturer), ProductCount)

-- OVER
-- Выражение OVER позволяет суммировать данные, при этому возвращая те строки, которые использовались для получения суммированных данных
-- Выражение OVER ставится после агрегатной функции, затем в скобках идет выражение PARTITION BY и столбец, по которому выполняется группировка.
SELECT ProductName, Manufacturer, ProductCount,
        COUNT(*) OVER (PARTITION BY Manufacturer) AS Models,
        SUM(ProductCount) OVER (PARTITION BY Manufacturer) AS Units
FROM Products


/*--------------------------------------------------------------------------------------------------*/
/*----------------------------Подзапросы------------------------------------------------------------*/

-- Вложенные запросы
SELECT *
FROM Products
WHERE Price > (SELECT AVG(Price) FROM Products)

SELECT  CreatedAt, 
        Price, 
        (SELECT ProductName FROM Products 
        WHERE Products.Id = Orders.ProductId) AS Product
FROM Orders

-- EXIST
-- WHERE [NOT] EXISTS (подзапрос)
-- поскольку при применении EXISTS не происходит выборка строк, 
-- то его использование более оптимально и эффективно, чем использование оператора IN
SELECT *
FROM Customers
WHERE EXISTS (SELECT * FROM Orders 
                  WHERE Orders.CustomerId = Customers.Id)


/*--------------------------------------------------------------------------------------------------*/
/*----------------------------Соединение таблиц в запросах------------------------------------------*/

-- Неявное соединение таблиц
SELECT * FROM Orders, Customers
--При такой выборке для каждая строка из таблицы Orders будет совмещаться с каждой строкой из таблицы Customers. 
--То есть, получится перекрестное соединение. 
--Например, в Orders три строки, а в Customers то же три строки, значит мы получим 3 * 3 = 9 строк:

-- OUTER JOIN
-- Перед оператором JOIN указывается одно из ключевых слов LEFT, RIGHT или FULL, которые определяют тип соединения:
-- LEFT: выборка будет содержать все строки из первой или левой таблицы
-- RIGHT: выборка будет содержать все строки из второй или правой таблицы
-- FULL: выборка будет содержать все строки из обоих таблиц

/*
Inner Join объединяет строки из дух таблиц при соответствии условию. 
Если одна из таблиц содержит строки, которые не соответствуют этому условию, то данные строки не включаются в выходную выборку. 
Left Join выбирает все строки первой таблицы и затем присоединяет к ним строки правой таблицы
*/

-- INNER JOIN
SELECT FirstName, CreatedAt, ProductCount, Price 
FROM Customers JOIN Orders 
ON Orders.CustomerId = Customers.Id

--LEFT JOIN
SELECT FirstName, CreatedAt, ProductCount, Price 
FROM Customers LEFT JOIN Orders 
ON Orders.CustomerId = Customers.Id

--RIGHT JOIN
SELECT FirstName, CreatedAt, ProductCount, Price, ProductId 
FROM Orders RIGHT JOIN Customers 
ON Orders.CustomerId = Customers.Id

-- Cross Join (Неявное соединение таблиц с использованием Cross Join)
SELECT * FROM Orders CROSS JOIN Customers

-- UNION - Объединение запросов (Одинаковые строки будут объеденены в 1)
SELECT FirstName, LastName 
FROM Customers
UNION SELECT FirstName, LastName FROM Employees

-- UNION ALL - Одинаковые строки будут оставлены
SELECT FirstName, LastName
FROM Customers
UNION ALL SELECT FirstName, LastName 
FROM Employees

-- EXCEPT 
-- Оператор EXCEPT позволяет найти разность двух выборок, то есть те строки которые есть 
-- в первой выборке, но которых нет во второй. Для его использования применяется следующий формальный синтаксис:
SELECT FirstName, LastName
FROM Customers
EXCEPT SELECT FirstName, LastName 
FROM Employees

-- INTERSECT
-- Оператор INTERSECT позволяет найти общие строки для двух выборок, то есть данный оператор выполняет операцию пересечения множеств. 
-- Для его использования применяется следующий формальный синтаксис:
SELECT FirstName, LastName
FROM Employees
INTERSECT SELECT FirstName, LastName 
FROM Customers