/*--------------------------------------------------------------------------------------------------*/
/*----------------------------Работа со строками----------------------------------------------------*/

--LEN: возвращает количество символов в строке. В качестве параметра в функцию передается строка, для которой надо найти длину:
SELECT LEN('Apple')  -- 5

-- LTRIM: удаляет начальные пробелы из строки. В качестве параметра принимает строку:
SELECT LTRIM('  Apple')

-- RTRIM: удаляет конечные пробелы из строки. В качестве параметра принимает строку:
SELECT RTRIM(' Apple    ')

-- CHARINDEX: возвращает индекс, по которому находится первое вхождение подстроки в строке. 
-- В качестве первого параметра передается подстрока, а в качестве второго - строка, в которой надо вести поиск:
SELECT CHARINDEX('pl', 'Apple') -- 3

-- PATINDEX: возвращает индекс, по которому находится первое вхождение определенного шаблона в строке:
SELECT PATINDEX('%p_e%', 'Apple')   -- 3

-- LEFT: вырезает с начала строки определенное количество символов. 
-- Первый параметр функции - строка, а второй - количество символов, которые надо вырезать сначала строки:
SELECT LEFT('Apple', 3) -- App

-- RIGHT: вырезает с конца строки определенное количество символов. 
-- Первый параметр функции - строка, а второй - количество символов, которые надо вырезать сначала строки:
SELECT RIGHT('Apple', 3)    -- ple

-- SUBSTRING: вырезает из строки подстроку определенной длиной, начиная с определенного индекса. 
-- Певый параметр функции - строка, второй - начальный индекс для вырезки, и третий параметр - количество вырезаемых символов:
SELECT SUBSTRING('Galaxy S8 Plus', 8, 2)    -- S8

-- REPLACE: заменяет одну подстроку другой в рамках строки. 
-- Первый параметр функции - строка, второй - подстрока, которую надо заменить, а третий - подстрока, на которую надо заменить:
SELECT REPLACE('Galaxy S8 Plus', 'S8 Plus', 'Note 8')   -- Galaxy Note 8

-- REVERSE: переворачивает строку наоборот:
SELECT REVERSE('123456789') -- 987654321

-- CONCAT: объединяет две строки в одну. В качестве параметра принимает от 2-х и более строк, которые надо соединить:
SELECT CONCAT('Tom', ' ', 'Smith')  -- Tom Smith

-- LOWER: переводит строку в нижний регистр:
SELECT LOWER('Apple')   -- apple

-- UPPER: переводит строку в верхний регистр
SELECT UPPER('Apple')   -- APPLE

-- SPACE: возвращает строку, которая содержит определенное количество пробелов


/*--------------------------------------------------------------------------------------------------*/
/*----------------------------Функции для работы с числами------------------------------------------*/

-- ROUND: округляет число. В качестве первого параметра передается число. 
-- Второй параметр указывает на длину. Если длина представляет положительное число, то оно указывает, до какой цифры после запятой идет округление. Если длина представляет отрицательное число, то оно указывает, до какой цифры с конца числа до запятой идет округление
SELECT ROUND(1342.345, 2)   -- 1342.350
SELECT ROUND(1342.345, -2)  -- 1300.000

-- ISNUMERIC: определяет, является ли значение числом. В качестве параметра функция принимает выражение. 
-- Если выражение является числом, то функция возвращает 1. Если не является, то возвращается 0.
SELECT ISNUMERIC(1342.345)          -- 1
SELECT ISNUMERIC('1342.345')        -- 1
SELECT ISNUMERIC('SQL')         -- 0
SELECT ISNUMERIC('13-04-2017')  -- 0

-- ABS: возвращает абсолютное значение числа.
SELECT ABS(-123)    -- 123

-- CEILING: возвращает наименьшее целое число, которое больше или равно текущему значению.
SELECT CEILING(-123.45)     -- -123
SELECT CEILING(123.45)      -- 124

-- FLOOR: возвращает наибольшее целое число, которое меньше или равно текущему значению.
SELECT FLOOR(-123.45)       -- -124
SELECT FLOOR(123.45)        -- 123

-- SQUARE: возводит число в квадрат.
SELECT SQUARE(5)        -- 25

-- SQRT: получает квадратный корень числа.
SELECT SQRT(225)        -- 15

-- RAND: генерирует случайное число с плавающей точкой в диапазоне от 0 до 1.
SELECT RAND()       -- 0.707365088352935
SELECT RAND()       -- 0.173808327956812

-- COS: возвращает косинус угла, выраженного в радианах
SELECT COS(1.0472)  -- 0.5 - 60 градусов

-- SIN: возвращает синус угла, выраженного в радианах1
SELECT SIN(1.5708)  -- 1 - 90 градусов

--TAN: возвращает тангенс угла, выраженного в радианах1
SELECT TAN(0.7854)  -- 1 - 45 градусов

/*--------------------------------------------------------------------------------------------------*/
/*----------------------------Функции по работе с датами и временем---------------------------------*/

-- GETDATE: возвращает текущую локальную дату и время на основе системных часов в виде объекта datetime
SELECT GETDATE()    -- 2017-07-28 21:34:55.830

-- GETUTCDATE: возвращает текущую локальную дату и время по гринвичу (UTC/GMT) в виде объекта datetime
SELECT GETUTCDATE()     -- 2017-07-28 18:34:55.830

-- SYSDATETIME: возвращает текущую локальную дату и время на основе системных часов, 
-- но отличие от GETDATE состоит в том, что дата и время возвращаются в виде объекта datetime2
SELECT SYSDATETIME()        -- 2017-07-28 21:02:22.7446744

-- SYSUTCDATETIME: возвращает текущую локальную дату и время по гринвичу (UTC/GMT) в виде объекта datetime2
SELECT SYSUTCDATETIME()     -- 2017-07-28 18:20:27.5202777

-- SYSDATETIMEOFFSET: возвращает объект datetimeoffset(7), который содержит дату и время относительно GMT
SELECT SYSDATETIMEOFFSET()      -- 2017-07-28 21:02:22.7446744 +03:00

-- DAY: возвращает день даты, который передается в качестве параметра
SELECT DAY(GETDATE())       -- 28

-- MONTH: возвращает месяц даты
SELECT MONTH(GETDATE())     -- 7

-- YEAR: возвращает год из даты
SELECT YEAR(GETDATE())      -- 2017

-- DATENAME: возвращает часть даты в виде строки. 
-- Параметр выбора части даты передается в качестве первого параметра, а сама дата передается в качестве второго параметра:
SELECT DATENAME(month, GETDATE())       -- July
-- Для определения части даты можно использовать следующие параметры (в скобках указаны их сокращенные версии):
-- year (yy, yyyy): год
-- quarter (qq, q): квартал
-- month (mm, m): месяц
-- dayofyear (dy, y): день года
-- day (dd, d): день месяца
-- week (wk, ww): неделя
-- weekday (dw): день недели
-- hour (hh): час
-- minute (mi, n): минута
-- second (ss, s): секунда
-- millisecond (ms): миллисекунда
-- microsecond (mcs): микросекунда
-- nanosecond (ns): наносекунда
-- tzoffset (tz): смешение в минутах относительно гринвича (для объекта datetimeoffset)

-- DATEPART: возвращает часть даты в виде числа. 
-- Параметр выбора части даты передается в качестве первого параметра (используются те же параметры, что и для DATENAME),
-- а сама дата передается в качестве второго параметра:
SELECT DATEPART(month, GETDATE())       -- 7

-- DATEADD: возвращает дату, которая является результатом сложения числа к определенному компоненту даты.
-- Первый параметр представляет компонент даты, описанный выше для функции DATENAME. Второй параметр - добавляемое количество.
-- Третий параметр - сама дата, к которой надо сделать прибавление:
SELECT DATEADD(month, 2, '2017-7-28')       -- 2017-09-28 00:00:00.000
SELECT DATEADD(day, 5, '2017-7-28')     -- 2017-08-02 00:00:00.000
SELECT DATEADD(day, -5, '2017-7-28')        -- 2017-07-23 00:00:00.000

-- Если добавляемое количество представляет отрицательное число, то фактически происходит уменьшение даты.
-- DATEDIFF: возвращает разницу между двумя датами. Первый параметр - компонент даты, который указывает, 
-- в каких единицах стоит измерять разницу. Второй и третий параметры - сравниваемые даты:
SELECT DATEDIFF(year, '2017-7-28', '2018-9-28')     -- разница 1 год
SELECT DATEDIFF(month, '2017-7-28', '2018-9-28')    -- разница 14 месяцев
SELECT DATEDIFF(day, '2017-7-28', '2018-9-28')      -- разница 427 дней

-- TODATETIMEOFFSET: возвращает значение datetimeoffset, которое является результатом сложения временного смещения 
-- с другим объектом datetimeoffset
SELECT TODATETIMEOFFSET('2017-7-28 01:10:22', '+03:00')

-- SWITCHOFFSET: возвращает значение datetimeoffset, которое является результатом сложения временного смещения с объектом datetime2
SELECT SWITCHOFFSET(SYSDATETIMEOFFSET(), '+02:30')

-- EOMONTH: возвращает дату последнего дня для месяца, который используется в переданной в качестве параметра дате.
SELECT EOMONTH('2017-02-05')    -- 2017-02-28
SELECT EOMONTH('2017-02-05', 3) -- 2017-05-31
-- В качестве необязательного второго параметра можно передавать количество месяцев, которые необходимо прибавить к дате. 
-- Тогда последний день месяца будет вычисляться для новой даты.

-- DATEFROMPARTS: по году, месяцу и дню создает дату
SELECT DATEFROMPARTS(2017, 7, 28)       -- 2017-07-28

-- ISDATE: проверяет, является ли выражение датой. Если является, то возвращает 1, иначе возвращает 0.
SELECT ISDATE('2017-07-28')     -- 1
SELECT ISDATE('2017-28-07')     -- 0
SELECT ISDATE('28-07-2017')     -- 0
SELECT ISDATE('SQL')            -- 0