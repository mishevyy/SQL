/*--------------------------------------------------------------------------------------------------*/
/*----------------------------Хранимые процедуры----------------------------------------------------*/

-- Создание хранимой процедуры
CREATE PROCEDURE ProductSummary AS
BEGIN
    SELECT ProductName AS Product, Manufacturer, Price
    FROM Products
END;

-- Удаление процедуры
-- DROP PROCEDURE ProductSummary

-- Выполнение процедуры
EXEC ProductSummary

-- Параметризированная процедура
-- CREATE PROCEDURE AddProduct
--     @name NVARCHAR(20),
--     @manufacturer NVARCHAR(20),
--     @count INT,
--     @price MONEY
-- AS
-- INSERT INTO Products(ProductName, Manufacturer, ProductCount, Price)
-- VALUES(@name, @manufacturer, @count, @price)

-- Вызов параметризированной процедуры
-- EXEC AddProduct @prodName, @company, @prodCount, @price


/*--------------------------------------------------------------------------------------------------*/
/*----------------------------Выходные параметры и возвращение результата---------------------------*/

-- Выходные параметры позволяют возвратить из процедуры некоторый результат. 
-- Выходные параметры определяются с помощью ключевого слова OUTPUT. Например, определим еще одну процедуру:
-- CREATE PROCEDURE GetPriceStats
--     @minPrice MONEY OUTPUT,
--     @maxPrice MONEY OUTPUT
-- AS
-- SELECT @minPrice = MIN(Price),  @maxPrice = MAX(Price)
-- FROM Products

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

-- Возвращение значения
-- CREATE PROCEDURE GetAvgPrice AS
-- DECLARE @avgPrice MONEY
-- SELECT @avgPrice = AVG(Price)
-- FROM Products
-- RETURN @avgPrice;
-- Вызов процедуры
-- EXEC @result = GetAvgPrice