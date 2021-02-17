/*----------------------------Проектирование базы данных---------------------------------------------*/
/*
    DDL (Data Definition Language / Язык определения данных). 
    К этому типу относятся различные команды, которые создают базу данных, таблицы, индексы, хранимые процедуры и т.д.
    CREATE: создает объекты базы данных (саму базу даных, таблицы, индексы и т.д.)
    ALTER: изменяет объекты базы данных
    DROP: удаляет объекты базы данных
    TRUNCATE: удаляет все данные из таблиц
*/


/*--------------------------------------------------------------------------------------------------*/
/*----------------------------Создание базы данных--------------------------------------------------*/

-- Создание базы данных
CREATE DATABASE usersdb

-- Использовать базу данных
USE usersdb

-- Прикрепление базы данных
CREATE DATABASE название_базы_данных
ON PRIMARY(FILENAME='путь_к_файлу_mdf_на_локальном_компьютере')
FOR ATTACH;

-- Удаление базы данных
DROP DATABASE contactsdb


/*--------------------------------------------------------------------------------------------------*/
/*----------------------------Создание и удаление таблиц--------------------------------------------*/

-- Создание таблицы
CREATE TABLE Customers
(
    Id INT,
    Age INT,
    FirstName NVARCHAR(20),
    LastName NVARCHAR(20),
    Email VARCHAR(30),
    Phone VARCHAR(20)
)

-- Удаление таблиц
DROP TABLE Customers

-- Переименование таблицы (применяется системная хранимая процедура "sp_rename")
EXEC sp_rename 'Users', 'UserAccounts';


/*--------------------------------------------------------------------------------------------------*/
/*----------------------------Атрибуты и ограничения столбцов и таблиц------------------------------*/

-- PRIMARY KEY - первичный ключ
CREATE TABLE Customers
(
    Id INT PRIMARY KEY,
    Age INT,
    FirstName NVARCHAR(20),
    LastName NVARCHAR(20),
    Email VARCHAR(30),
    Phone VARCHAR(20)
    -- PRIMARY KEY(OrderId, ProductId) (Первичный ключ может быть составным (compound key))
)

-- IDENTITY(seed, increment) Добавляет автоинкремент столбцу (начальное значение, шаг инкремента)
-- Обычно используется в связке PRIMARY KEY
CREATE TABLE Customers
(
    Id INT PRIMARY KEY IDENTITY(1, 1),
    Age INT,
    FirstName NVARCHAR(20),
    LastName NVARCHAR(20),
    Email VARCHAR(30),
    Phone VARCHAR(20)
)

-- UNIQUE - Говорит, чтобы столбец имел только уникальные значения
CREATE TABLE Customers
(
    Id INT PRIMARY KEY IDENTITY,
    Age INT,
    FirstName NVARCHAR(20),
    LastName NVARCHAR(20),
    Email VARCHAR(30) UNIQUE,
    Phone VARCHAR(20) UNIQUE
)

-- NULL и NOT NULL (по умолчнию NULL) 
CREATE TABLE Customers
(
    Id INT PRIMARY KEY IDENTITY,
    Age INT,
    FirstName NVARCHAR(20) NOT NULL,
    LastName NVARCHAR(20) NOT NULL,
    Email VARCHAR(30) UNIQUE,
    Phone VARCHAR(20) UNIQUE
)

-- DEFAULT - значение по умолчнию. (Используется при вставке значении)
CREATE TABLE Customers
(
    Id INT PRIMARY KEY IDENTITY,
    Age INT DEFAULT 18,
    FirstName NVARCHAR(20) NOT NULL,
    LastName NVARCHAR(20) NOT NULL,
    Email VARCHAR(30) UNIQUE,
    Phone VARCHAR(20) UNIQUE
);

-- CHECK - определяет проверку значений (Используется при вставке значении)
CREATE TABLE Customers
(
    Id INT PRIMARY KEY IDENTITY,
    Age INT DEFAULT 18 CHECK(Age >0 AND Age < 100),
    FirstName NVARCHAR(20) NOT NULL,
    LastName NVARCHAR(20) NOT NULL,
    Email VARCHAR(30) UNIQUE CHECK(Email !=''),
    Phone VARCHAR(20) UNIQUE CHECK(Phone !='')
);

-- Оператор CONSTRAINT. Установка имени ограничений
-- "PK_" - для PRIMARY KEY
-- "FK_" - для FOREIGN KEY
-- "CK_" - для CHECK
-- "UQ_" - для UNIQUE
-- "DF_" - для DEFAULT
CREATE TABLE Customers
(
    Id INT IDENTITY,
    Age INT, 
    FirstName NVARCHAR(20) NOT NULL,
    LastName NVARCHAR(20) NOT NULL,
    Email VARCHAR(30),
    Phone VARCHAR(20),
    CONSTRAINT DF_Customer_Age DEFAULT 18,
    CONSTRAINT PK_Customer_Id PRIMARY KEY (Id), 
    CONSTRAINT CK_Customer_Age CHECK(Age >0 AND Age < 100),
    CONSTRAINT UQ_Customer_Email UNIQUE (Email),
    CONSTRAINT UQ_Customer_Phone UNIQUE (Phone)
)


/*--------------------------------------------------------------------------------------------------*/
/*----------------------------Внешние ключи---------------------------------------------------------*/

-- Общий синтаксис установки внешнего ключа на уровне столбца
-- [FOREIGN KEY] REFERENCES главная_таблица (столбец_главной_таблицы)
--     [ON DELETE {CASCADE|NO ACTION}]
--     [ON UPDATE {CASCADE|NO ACTION}]

-- Определение внешнего ключа
CREATE TABLE Orders
(
    Id INT PRIMARY KEY IDENTITY,
    CustomerId INT,
    CreatedAt Date,
    FOREIGN KEY (CustomerId)  REFERENCES Customers (Id)
);

-- Определение внешнего ключа с помощью оператора CONSTRAINT
CREATE TABLE Orders
(
    Id INT PRIMARY KEY IDENTITY,
    CustomerId INT,
    CreatedAt Date,
    CONSTRAINT FK_Orders_To_Customers FOREIGN KEY (CustomerId)  REFERENCES Customers (Id)
);


/*--------------------------------------------------------------------------------------------------*/
/*----------------------------Поведение при удалении данных-----------------------------------------*/

-- ON DELETE и ON UPDATE
/*
С помощью выражений ON DELETE и ON UPDATE можно установить действия, 
которые выполняться соответственно при удалении и изменении связанной строки из главной таблицы. 
И для определения действия мы можем использовать следующие опции:

CASCADE: автоматически удаляет или изменяет строки из зависимой таблицы при удалении или изменении связанных строк в главной таблице.

NO ACTION: предотвращает какие-либо действия в зависимой таблице при удалении или изменении связанных строк в главной таблице. 
То есть фактически какие-либо действия отсутствуют.

SET NULL: при удалении связанной строки из главной таблицы устанавливает для столбца внешнего ключа значение NULL.

SET DEFAULT: при удалении связанной строки из главной таблицы устанавливает для столбца внешнего ключа значение по умолчанию, 
которое задается с помощью атрибуты DEFAULT. Если для столбца не задано значение по умолчанию, то в качестве него применяется значение NULL.
*/

-- Каскадное удаление
CREATE TABLE Orders
(
    Id INT PRIMARY KEY IDENTITY,
    CustomerId INT,
    CreatedAt Date,
    FOREIGN KEY (CustomerId) REFERENCES Customers (Id) ON DELETE CASCADE
)

-- Установка NULL
CREATE TABLE Orders
(
    Id INT PRIMARY KEY IDENTITY,
    CustomerId INT,
    CreatedAt Date,
    FOREIGN KEY (CustomerId) REFERENCES Customers (Id) ON DELETE SET NULL
)

-- Установка значения по умолчанию
CREATE TABLE Orders
(
    Id INT PRIMARY KEY IDENTITY,
    CustomerId INT,
    CreatedAt Date,
    FOREIGN KEY (CustomerId) REFERENCES Customers (Id) ON DELETE SET DEFAULT
)


/*--------------------------------------------------------------------------------------------------*/
/*----------------------------Изменение таблицы-----------------------------------------------------*/

--ALTER TABLE
-- ALTER TABLE название_таблицы [WITH CHECK | WITH NOCHECK]
-- { ADD название_столбца тип_данных_столбца [атрибуты_столбца] | 
--   DROP COLUMN название_столбца |
--   ALTER COLUMN название_столбца тип_данных_столбца [NULL|NOT NULL] |
--   ADD [CONSTRAINT] определение_ограничения |
--   DROP [CONSTRAINT] имя_ограничения}

-- Добавление нового столбца
ALTER TABLE Customers
ADD Address NVARCHAR(50) NOT NULL;

ALTER TABLE Customers
ADD Address NVARCHAR(50) NOT NULL DEFAULT 'Неизвестно';

-- Удаление столбца
ALTER TABLE Customers
DROP COLUMN Address;

-- Изменение типа столбца
ALTER TABLE Customers
ALTER COLUMN FirstName NVARCHAR(200);

-- Добавление ограничения CHECK
ALTER TABLE Customers -- WITH NOCHECK
ADD CHECK (Age > 21);

-- Добавление первичного ключа
ALTER TABLE Orders
ADD PRIMARY KEY (Id);

-- Добавление внешнего ключа
ALTER TABLE Orders
ADD FOREIGN KEY(CustomerId) REFERENCES Customers(Id);

 -- Добавление ограничений с именами
ALTER TABLE Orders
ADD CONSTRAINT PK_Orders_Id PRIMARY KEY (Id),
    CONSTRAINT FK_Orders_To_Customers FOREIGN KEY(CustomerId) REFERENCES Customers(Id); 

ALTER TABLE Customers
ADD CONSTRAINT CK_Age_Greater_Than_Zero CHECK (Age > 0);

-- Удаление ограничений
ALTER TABLE Orders
DROP FK_Orders_To_Customers;


/*--------------------------------------------------------------------------------------------------*/
/*----------------------------Пакеты. Команда GO----------------------------------------------------*/

-- Смысл разделения SQL-выражений на пакеты состоит в том, что одни выражения должны успешно выполниться до запуска других выражений. 
-- Например, при добавлении таблиц мы должны бы уверены, что была создана база данных, в которой мы собираемся создать таблицы
CREATE DATABASE internetstore;
GO