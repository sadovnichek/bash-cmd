USE master
/*ОБРАЩЕНИЕ К СИСТЕМНОЙ БАЗЕ SQL СЕРВЕРА
ДЛЯ СОЗДАНИЯ ПОЛЬЗОВАТЕЛЬСКОЙ БАЗЫ ДАННЫХ*/
GO --РАЗДЕЛИТЕЛЬ БАТЧЕЙ (BATH)

IF  EXISTS (
	SELECT name 
		FROM sys.databases 
		WHERE name = N'KN304_KAPKAEV'
)
ALTER DATABASE [KN304_KAPKAEV] set single_user with rollback immediate
GO
/* ПРОВЕРЯЕМ, СУЩЕСТВУЕТ ЛИ НА СЕРВЕРЕ БАЗА ДАННЫХ
С ИМЕНЕМ [ИМЯ БАЗЫ], ЕСЛИ ДА, ТО ЗАКРЫВАЕМ ВСЕ ТЕКУЩИЕ
 СОЕДИНЕНИЯ С ЭТОЙ БАЗОЙ */

IF  EXISTS (
	SELECT name 
		FROM sys.databases 
		WHERE name = N'KN304_KAPKAEV'
)
DROP DATABASE [KN304_KAPKAEV]
GO
/* СНОВА ПРОВЕРЯЕМ, СУЩЕСТВУЕТ ЛИ НА СЕРВЕРЕ БАЗА ДАННЫХ
С ИМЕНЕМ [ИМЯ БАЗЫ], ЕСЛИ ДА, УДАЛЯЕМ ЕЕ С СЕРВЕРА */

/* ДАННЫЙ БЛОК НЕОБХОДИМ ДЛЯ КОРРЕКТНОГО ПЕРЕСОЗДАНИЯ БАЗЫ
ДАННЫХ С ИМЕНЕМ [ИМЯ БАЗЫ] ПРИ НЕОБХОДИМОСТИ */

CREATE DATABASE [KN304_KAPKAEV]
GO
-- СОЗДАЕМ БАЗУ ДАННЫХ

USE [KN304_KAPKAEV]
GO
/* ПЕРЕХОДИМ К СОЗДАННОЙ БАЗЕ ДАННЫХ ДЛЯ ПОСЛЕДУЮЩЕЙ РАБОТЫ С НЕЙ 
ИЛИ С ЭТИХ КОМАНД ПРОДОЛЖАЕМ РАБОТУ С БАЗОЙ ДАННЫХ ЕСЛИ ОНА
 УЖЕ СУЩЕСТВУЕТ НА СЕРВЕРЕ */

IF EXISTS(
  SELECT *
    FROM sys.schemas
   WHERE name = N'Kapkaev'
) 
 DROP SCHEMA Kapkaev
GO
/*ПРОВЕРЯЕМ, СУЩЕСТВУЕТ ЛИ В БАЗЕ ДАННЫХ
 [ИМЯ БАЗЫ] СХЕМА С ИМЕНЕМ Фамилия, ЕСЛИ ДА,
  ТО ПРЕДВАРИТЕЛЬНО УДАЛЯЕМ ЕЕ ИЗ БАЗЫ
  ЕСЛИ ВЫ УАЛЯЕТЕ ВСЮ БАЗУ ЦЕЛИКОМ - ЭТА ЧАСТЬ СКРИПТА НЕ НУЖНА */

CREATE SCHEMA Kapkaev 
GO
/*СОЗДАЕМ В БАЗЕ ДАННЫХ
 [ИМЯ БАЗЫ] СХЕМУ С ИМЕНЕМ Фамилия */

IF OBJECT_ID('[KN304_KAPKAEV].Kapkaev.ut_students', 'U') IS NOT NULL
  DROP TABLE  [KN304_KAPKAEV].Kapkaev.ut_students
GO

/*ПРОВЕРЯЕМ, СУЩЕСТВУЕТ ЛИ В БАЗЕ ДАННЫХ
 [ИМЯ БАЗЫ] И СХЕМЕ С ИМЕНЕМ Фамилия ТАБЛИЦА ut_students ЕСЛИ ДА, 
  ТО ПРЕДВАРИТЕЛЬНО УДАЛЯЕМ ЕЕ ИЗ БАЗЫ И СХЕМЫ.
  ЕСЛИ ВЫ УАЛЯЕТЕ ВСЮ БАЗУ ЦЕЛИКОМ - ЭТА ЧАСТЬ СКРИПТА НЕ НУЖНА */

CREATE TABLE [KN304_KAPKAEV].Kapkaev.Shop
(
	shop_id tinyint NOT NULL, 
	shop_name nvarchar(15) NULL, 
	street nvarchar(20) NULL,
	house_num varchar(10) NULL,

    CONSTRAINT PK_shop_id PRIMARY KEY (shop_id) 
)
GO

/*СОЗДАЕМ В БАЗЕ ДАННЫХ [ИМЯ БАЗЫ] В СХЕМЕ С ИМЕНЕМ
 Фамилия ТАБЛИЦУ ut_students С ТРЕМЯ ТЕКСТОВЫМИ ПОЛЯМИ 
 И ПЕРВИЧНЫМ КЛЮЧОМ (PRIMARY KEY),
 ГДЕ PK_NumberZach - ИМЯ КЛЮЧА, А NumberZach - ИМЯ КЛЮЧЕВОГО ПОЛЯ*/

ALTER TABLE [ИМЯ БАЗЫ].Фамилия.ut_students ADD 
	NumberGroup tinyint null,
	Kurs char(1) null
	GO

ALTER TABLE [ИМЯ БАЗЫ].Фамилия.ut_students ADD 
	Birthday date null
GO

ALTER TABLE [ИМЯ БАЗЫ].Фамилия.ut_students 
ALTER COLUMN Birthday date  NOT NULL
GO

/*СУЩЕСТВУЮЩИЕ ОБЪЕКТЫ БАЗЫ ДАННЫХ МОЖНО ИЗМЕНЯТЬ С ПОМОЩЬЮ
ИНСТРУКЦИИ ALTER (ИМЯ ОБЪЕКТА) */


--DROP TABLE	[ИМЯ БАЗЫ].Фамилия.ut_students
--GO

/*УДАЛЕНИЕ ОБЪЕКТА ТАБЛИЦЫ ИЗ БАЗЫ ДАННЫХ  */

CREATE TABLE [KN304_KAPKAEV].Kapkaev.ItemGroup
(
	group_id smallint Not NULL,
	group_name varchar(50) NULL
	CONSTRAINT PK_group_id PRIMARY KEY (group_id) 
)
GO

CREATE TABLE [KN304_KAPKAEV].Kapkaev.Items
(
	item_id int Not NULL,
	group_name varchar(50) NULL,
	group_id smallint Not NULL,
	item_name varchar(50) NULL,
	unit varchar(10) NULL,

	CONSTRAINT PK_item_id PRIMARY KEY (item_id),

	CONSTRAINT FK_group_id FOREIGN KEY (group_id)
	REFERENCES Kapkaev.ItemGroup (group_id)
)
GO

CREATE TABLE [KN304_KAPKAEV].Kapkaev.Storage
(
	item_id int Not NULL,
	shop_id tinyint Not NULL,
	date_ smalldatetime Not Null,
	price decimal(6, 2) Not Null,
	count_ decimal(6, 3) Not Null,
	difference_ smallint Not Null

	CONSTRAINT FK_shop_id FOREIGN KEY (shop_id)
	REFERENCES Kapkaev.Shop (shop_id),

	CONSTRAINT FK_item_id FOREIGN KEY (item_id)
	REFERENCES Kapkaev.Items (item_id)
)
GO

/*СОЗДАЕМ В БАЗЕ ДАННЫХ [ИМЯ БАЗЫ] В СХЕМЕ С ИМЕНЕМ
 Фамилия ТАБЛИЦУ ut_nameGroup С  ТЕКСТОВЫМ ПОЛЯМ И ДВУМЯ ЦЕЛОЧИСЛЕННЫМИ
 ПОЛЯМИ. ОДНО ПОЛЕ ДЕЛАЕМ ИДЕНТИФИКАТОРОМ, В ДРУГОЕ ПОЛЕ ВНОСИМ ЗНАЧЕНИЕ 
 ПО УМОЛЧЕНИЮ. СОЗДАЕМ ПЕРВИЧНЫЙ КЛЮЧ (PRIMARY KEY),
 ГДЕ PK_NumberGroup - ИМЯ КЛЮЧА, А NumberGroup - ИМЯ КЛЮЧЕВОГО ПОЛЯ*/
 
ALTER TABLE [ИМЯ БАЗЫ].Фамилия.ut_students ADD 
	CONSTRAINT FK_NameGroup FOREIGN KEY (NumberGroup) 
	REFERENCES [ИМЯ БАЗЫ].Фамилия.ut_nameGroup(NumberGroup)
	ON UPDATE CASCADE 
GO		
 /*СОЗДАЕМ В ТАБЛИЦЕ ut_students ВНЕШНИЙ КЛЮЧ  (FOREIGN KEY)
  С ИМЕНЕМ FK_NameGroup, СВЯЗЫВАЮЩИЙ ПОЛЕ NumberGroup ТАБЛИЦЫ ut_students
  С ПОЛЕМ NumberGroup ТАБЛИЦЫ ut_nameGroup. СВЯЗЬ МНОГИЕ-К-ОДНОМУ.
 ВНЕШНИЙ КЛЮЧ СОЗДАЕМ С ПОМОЩЬЮ ИНСТРУКЦИИ ALTER TABLE,
 ПОСКОЛЬКУ НАРУШЕНА ОЧЕРЕДНОСТЬ СОЗДАНИЯ ТАБЛИЦ*/

 ALTER TABLE [ИМЯ БАЗЫ].Фамилия.ut_nameGroup ADD 
	CONSTRAINT CK_Kurs 
	CHECK (Kurs>0 and Kurs<=6)
GO	
/*УСТАНАВЛИВАЕМ ОГРАНИЧЕНИЕ (CHECK) В ТАБЛИЦЕ ut_nameGroup НА ПОЛЕ Kurs.
 CK_Kurs - ИМЯ ОГРАНИЧЕНИЯ*/

 INSERT INTO [ИМЯ БАЗЫ].Фамилия.ut_nameGroup 
 (NumberGroup,NameGroup)
 VALUES 
 (1,N'КН-301')
 ,(2,N'КН-303')
 ,(3,N'КБ-301')	
GO	
/*ВНОСИМ ДАННЫЕ В ТАБЛИЦУ ut_nameGroup ТОЛЬКО В ДВА ПОЛЕ 
 ПОЛЕ Kurs ЗАПОЛНЯЕТСЯ АВТОМАТИЧЕСКИ*/

SELECT * From [ИМЯ БАЗЫ].Фамилия.ut_nameGroup 
--ПРОСМАТРИВАЕМ СОДЕРЖИМОЕ ТАБЛИЦЫ ut_nameGroup


INSERT INTO [KN304_KAPKAEV].Kapkaev.Shop 
  VALUES 
	(1,N'Monetka', N'Flower','35'),
	(2,N'Magnit', N'Stroiteley','55'),
	(3,N'Kirovskiy', N'Kosmonavtov','80'),
	(4,N'Pyaterochka', N'Morskaya','8')

INSERT INTO [KN304_KAPKAEV].Kapkaev.ItemGroup 
  VALUES 
	(880,N'Fruits'),
	(55,N'Vegetables'),
	(353,N'Milks'),
	(5,N'Meat')

INSERT INTO [KN304_KAPKAEV].Kapkaev.Items
  VALUES 
	(89,N'Fruits'),
	(55,N'Vegetables'),
	(353,N'Milks'),
	(5,N'Meat')

 /*ВНОСИМ ДАННЫЕ В ТАБЛИЦУ ut_students, 
 ПОСКОЛЬКУ ЗАПОЛНЯЮТСЯ ВСЕ ПОЛЯ, ПИШУТЬСЯ ТОЛЬКО ДАННЫЕ
 В ПОРЯДКЕ СЛЕДОВАНИЯ ПОЛЕЙ В ТАБЛИЦЕ.
 ОБРАТИТЕ ВНИМАНИЕ НА ВВОД ДАТЫ!!! */

SELECT * From [ИМЯ БАЗЫ].Фамилия.ut_students
--ПРОСМАТРИВАЕМ СОДЕРЖИМОЕ ТАБЛИЦЫ ut_students   

--DELETE FROM [ИМЯ БАЗЫ].Фамилия.ut_students 
/*УДАЛЯЕМ ВСЕ ДАННЫЕ ИЗ ТАБЛИЦЫ  ut_students. 
САМА ТАБЛИЦА ОСТАЕТСЯ В БАЗЕ ДАННЫХ*/

UPDATE [ИМЯ БАЗЫ].Фамилия.ut_nameGroup
SET NumberGroup = 7	where NumberGroup =2

--ПРОВЕРЯЕМ ОГРАНИЧЕНИЕ ON UPDATE CASCADE 

SELECT * From [ИМЯ БАЗЫ].Фамилия.ut_nameGroup 
--ПРОСМАТРИВАЕМ СОДЕРЖИМОЕ ТАБЛИЦЫ ut_nameGroup

SELECT * From [ИМЯ БАЗЫ].Фамилия.ut_students
--ПРОСМАТРИВАЕМ СОДЕРЖИМОЕ ТАБЛИЦЫ ut_students   

