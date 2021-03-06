/*--------------------------------------------------------------------------------------------------*/
/*----------------------------@@IDENTITY------------------------------------------------------------*/

-- С помощью глобальной переменной @@IDENTITY можно получить идентификатор добавленной записи.
-- CREATE PROCEDURE CreateProduct
--     @name NVARCHAR(20),
--     @manufacturer NVARCHAR(20),
--     @count INT,
--     @price MONEY,
--     @id INT OUTPUT
-- AS
--     INSERT INTO Products(ProductName, Manufacturer, ProductCount, Price)
--     VALUES(@name, @manufacturer, @count, @price)
--     SET @id = @@IDENTITY
-- Вызов процедуры
-- EXEC CreateProduct 'LG V30', 'LG', 3, 28000, @id OUTPUT


/*--------------------------------------------------------------------------------------------------*/
/*----------------------------Функции NEWID, ISNULL и COALESCE--------------------------------------*/

-- NEWID
-- Для генерации объекта UNIQUEIDENTIFIER, то есть некоторого уникального значения, используется функция NEWID(). 
-- Например, мы можем определить для столбца первичного ключа тип UNIQUEIDENTIFIER и по умолчанию присваивать ему значение функции NEWID:
CREATE TABLE Clients
(
    Id UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    FirstName NVARCHAR(20) NOT NULL,
    LastName NVARCHAR(20) NOT NULL,
    Phone NVARCHAR(20) NULL,
    Email NVARCHAR(20) NULL
)

-- ISNULL
-- Функция ISNULL проверяет значение некоторого выражения. Если оно равно NULL, 
-- то функция возвращает значение, которое передается в качестве второго параметра:
-- ISNULL(выражение, значение)
SELECT FirstName, LastName,
        ISNULL(Phone, 'не определено') AS Phone,
        ISNULL(Email, 'неизвестно') AS Email
FROM Clients

-- COALESCE
-- Функция COALESCE принимает список значений и возвращает первое из них, которое не равно NULL:
-- COALESCE(выражение_1, выражение_2, выражение_N)
SELECT FirstName, LastName,
        COALESCE(Phone, Email, 'не определено') AS Contacts
FROM Clients


/*--------------------------------------------------------------------------------------------------*/
/*----------------------------Переменные------------------------------------------------------------*/

-- Использование переменных
-- DECLARE @название_переменной тип_данных

DECLARE @name NVARCHAR(20) -- Объявление
SET @name='Tom'; -- Установка
PRINT 'Hello World' -- Вывод
SELECT @name; -- Вывод


/*--------------------------------------------------------------------------------------------------*/
/*----------------------------Табличные переменные--------------------------------------------------*/

-- Табличные переменные (table variable) позволяют сохранить содержимое целой таблицы. 
-- Формальный синтаксис определения подобной переменной во многом похож на создание таблицы:
-- DECLARE @табличная_переменная TABLE
-- (столбец_1 тип_данных [атрибуты_столбца], 
--  столбец_2 тип_данных [атрибуты_столбца] ....)
--  [атрибуты_таблицы]

DECLARE @ABrends TABLE (ProductId INT,  ProductName NVARCHAR(20))
 
INSERT INTO @ABrends
VALUES(1, 'iPhone 8'),
(2, 'Samsumg Galaxy S8')
 
SELECT * FROM @ABrends


/*--------------------------------------------------------------------------------------------------*/
/*----------------------------Условные выражения----------------------------------------------------*/
-- IF условие
--     {инструкция|BEGIN...END}
-- [ELSE
--     {инструкция|BEGIN...END}]
DECLARE @lastDate DATE
 
SELECT @lastDate = MAX(CreatedAt) FROM Orders
 
IF DATEDIFF(day, @lastDate, GETDATE()) > 10
    PRINT 'За последние десять дней не было заказов'
ELSE
    PRINT 'За последние десять дней были заказы'


/*--------------------------------------------------------------------------------------------------*/
/*----------------------------Циклы-----------------------------------------------------------------*/

-- WHILE условие
--     {инструкция|BEGIN...END}

DECLARE @number INT, @factorial INT
SET @factorial = 1;
SET @number = 5;
 
WHILE @number > 0
    BEGIN
        SET @factorial = @factorial * @number
        SET @number = @number - 1
    END;
 
PRINT @factorial

-- Операторы BREAK и CONTINUE
DECLARE @number INT
SET @number = 1
 
WHILE @number < 10
    BEGIN
        PRINT CONVERT(NVARCHAR, @number)
        SET @number = @number + 1
        IF @number = 7
            BREAK;
        IF @number = 4
            CONTINUE;
        PRINT 'Конец итерации'
    END;


/*--------------------------------------------------------------------------------------------------*/
/*----------------------------Обработка ошибок------------------------------------------------------*/

-- BEGIN TRY
--     инструкции
-- END TRY
-- BEGIN CATCH
--     инструкции
-- END CATCH

-- В блоке CATCH для обаботки ошибки мы можем использовать ряд функций:
-- ERROR_NUMBER(): возвращает номер ошибки
-- ERROR_MESSAGE(): возвращает сообщение об ошибке
-- ERROR_SEVERITY(): возвращает степень серьезности ошибки. 
-- Степень серьезности представляет числовое значение. И если оно равно 10 и меньше, 
-- то такая ошибка рассматривается как предупреждение и не обрабатывается конструкцией TRY...CATCH. 
-- Если же это значение равно 20 и выше, то такая ошибка приводит к закрытию подключения к базе данных, 
-- если она не обрабатывается конструкцией TRY...CATCH.
-- ERROR_STATE(): возвращает состояние ошибки

BEGIN TRY
    INSERT INTO Accounts VALUES(NULL, NULL)
    PRINT 'Данные успешно добавлены!'
END TRY
BEGIN CATCH
    PRINT 'Error ' + CONVERT(VARCHAR, ERROR_NUMBER()) + ':' + ERROR_MESSAGE()
END CATCH


/*--------------------------------------------------------------------------------------------------*/
/*----------------------------Преобразование данных-------------------------------------------------*/

-- Функция CAST преобразует выражение одного типа к другому. Она имеет следующую форму:
-- CAST(выражение AS тип_данных)
SELECT Id, CAST(CreatedAt AS nvarchar) + '; total: ' + CAST(Price * ProductCount AS nvarchar) 
FROM Orders

-- Convert
-- Большую часть преобразований охватывает функция CAST. 
-- Если же необходимо какое-то дополнительное форматирование, то можно использовать функцию CONVERT. Она имеет следующую форму:
-- CONVERT(тип_данных, выражение [, стиль])
SELECT CONVERT(nvarchar, CreatedAt, 3), 
       CONVERT(nvarchar, Price * ProductCount, 1) 
FROM Orders
-- стиль форматирования дат и времени:
-- 0 или 100 - формат даты "Mon dd yyyy hh:miAM/PM" (значение по умолчанию)
-- 1 или 101 - формат даты "mm/dd/yyyy"
-- 3 или 103 - формат даты "dd/mm/yyyy"
-- 7 или 107 - формат даты "Mon dd, yyyy hh:miAM/PM"
-- 8 или 108 - формат даты "hh:mi:ss"
-- 10 или 110 - формат даты "mm-dd-yyyy"
-- 14 или 114 - формат даты "hh:mi:ss:mmmm" (24-часовой формат времени)
-- стиль форматирования типа money в строку
-- 0 - в дробной части числа остаются только две цифры (по умолчанию)
-- 1 - в дробной части числа остаются только две цифры, а для разделения разрядов применяется запятая
-- 2 - в дробной части числа остаются только четыре цифры

-- TRY_CONVERT
-- При использовании функций CAST и CONVERT SQL Server выбрасывает исключение, если данные нельзя привести к определенному типу. 
-- Например: Чтобы избежать генерации исключения можно использовать функцию TRY_CONVERT. 
-- Ее использование аналогично функции CONVERT за тем исключением, что если выражение не удается преобразовать к нужному типу, 
-- то функция возвращает NULL:
SELECT CONVERT(int, 'sql')


-- Дополнительные функции
-- STR(float [, length [,decimal]]): преобразует число в строку. 
-- Второй параметр указывает на длину строки, а третий - сколько знаков в дробной части числа надо оставлять
-- CHAR(int): преобразует числовой код ASCII в символ. Нередко используется для тех ситуаций, 
-- когда необходим символ, который нельзя ввести с клавиатуры
-- ASCII(char): преобразует символ в числовой код ASCII
-- NCHAR(int): преобразует числовой код UNICODE в символ
-- UNICODE(char): преобразует символ в числовой код UNICODE
SELECT STR(123.4567, 6,2)   -- 123.46
SELECT CHAR(219)            --  Ы
SELECT ASCII('Ы')           -- 219
SELECT NCHAR(1067)          -- Ы
SELECT UNICODE('Ы')     -- 1067


/*--------------------------------------------------------------------------------------------------*/
/*----------------------------Функции CASE и IIF----------------------------------------------------*/

-- CASE
-- Функция CASE проверяет значение некоторого выражение, и в зависимости от результата проверки может возвращать тот или иной результат.
-- CASE выражение
--     WHEN значение_1 THEN результат_1
--     WHEN значение_2 THEN результат_2
--     .................................
--     WHEN значение_N THEN результат_N
--     [ELSE альтернативный_результат]
-- END
SELECT ProductName, Manufacturer,
    CASE ProductCount
        WHEN 1 THEN 'Товар заканчивается'
        WHEN 2 THEN 'Мало товара'
        WHEN 3 THEN 'Есть в наличии'
        ELSE 'Много товара'
    END AS EvaluateCount
FROM Products


-- IIF
-- Функция IIF в зависимости от результата условного выражения возвращает одно из двух значений. 
-- Общая форма функции выглядит следующим образом:\
-- IIF(условие, значение_1, значение_2)
SELECT ProductName, Manufacturer,
    IIF(ProductCount>3, 'Много товара', 'Мало товара')
FROM Products
