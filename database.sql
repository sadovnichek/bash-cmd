USE master
/*ОБРАЩЕНИЕ К СИСТЕМНОЙ БАЗЕ SQL СЕРВЕРА
ДЛЯ СОЗДАНИЯ ПОЛЬЗОВАТЕЛЬСКОЙ БАЗЫ ДАННЫХ*/
GO --РАЗДЕЛИТЕЛЬ БАТЧЕЙ (BATH)

IF  EXISTS (
	SELECT name 
		FROM sys.databases 
		WHERE name = N'KN304_Kapkaev'
)
ALTER DATABASE [KN304_Kapkaev] set single_user with rollback immediate
GO
/* ПРОВЕРЯЕМ, СУЩЕСТВУЕТ ЛИ НА СЕРВЕРЕ БАЗА ДАННЫХ
С ИМЕНЕМ [ИМЯ БАЗЫ], ЕСЛИ ДА, ТО ЗАКРЫВАЕМ ВСЕ ТЕКУЩИЕ
 СОЕДИНЕНИЯ С ЭТОЙ БАЗОЙ */

IF  EXISTS (
	SELECT name 
		FROM sys.databases 
		WHERE name = N'KN304_Kapkaev'
)
DROP DATABASE [KN304_Kapkaev]
GO
/* СНОВА ПРОВЕРЯЕМ, СУЩЕСТВУЕТ ЛИ НА СЕРВЕРЕ БАЗА ДАННЫХ
С ИМЕНЕМ [ИМЯ БАЗЫ], ЕСЛИ ДА, УДАЛЯЕМ ЕЕ С СЕРВЕРА */

/* ДАННЫЙ БЛОК НЕОБХОДИМ ДЛЯ КОРРЕКТНОГО ПЕРЕСОЗДАНИЯ БАЗЫ
ДАННЫХ С ИМЕНЕМ [ИМЯ БАЗЫ] ПРИ НЕОБХОДИМОСТИ */

CREATE DATABASE [KN304_Kapkaev]
GO
-- СОЗДАЕМ БАЗУ ДАННЫХ

USE [KN304_Kapkaev]
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

IF OBJECT_ID('[KN304_Kapkaev].Kapkaev.Shop', 'U') IS NOT NULL
  DROP TABLE  [KN304_Kapkaev].Kapkaev.Shop
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

CREATE TABLE [KN304_Kapkaev].Kapkaev.ItemGroup
(
	group_id smallint Not NULL,
	group_name varchar(50) NULL

	CONSTRAINT PK_group_id PRIMARY KEY (group_id) 
)
GO

CREATE TABLE [KN304_Kapkaev].Kapkaev.Items
(
	item_id int Not NULL,
	group_id smallint Not NULL,
	item_name varchar(50) NULL,
	unit varchar(10) NULL,

	CONSTRAINT PK_item_id PRIMARY KEY (item_id),

	CONSTRAINT FK_group_id FOREIGN KEY (group_id)
	REFERENCES Kapkaev.ItemGroup (group_id)
)
GO

CREATE TABLE [KN304_Kapkaev].Kapkaev.Storage
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


INSERT INTO [KN304_Kapkaev].Kapkaev.Shop 
  VALUES 
	(1,N'Monetka', N'Flower','35'),
	(2,N'Magnit', N'Stroiteley','55'),
	(3,N'Kirovskiy', N'Kosmonavtov','80'),
	(4,N'Pyaterochka', N'Morskaya','8')

SELECT * From [KN304_Kapkaev].Kapkaev.Shop

INSERT INTO [KN304_KAPKAEV].Kapkaev.ItemGroup 
  VALUES 
	(880,N'Fruits'),
	(55,N'Vegetables'),
	(353,N'Milks'),
	(5,N'Meat')

SELECT * From [KN304_Kapkaev].Kapkaev.ItemGroup

INSERT INTO [KN304_Kapkaev].Kapkaev.Items
  VALUES 
	(89, 880, N'Apples', N'kg'),
	(82, 880, N'Bananas', N'kg'),
	(63, 55, N'Carrot', N'kg'),
	(5, 55, N'Potatos', N'kg'),
	(68, 55, N'Tomato', N'kg'),
	(189, 353, N'Milk', N'l'),
	(282, 353, N'Quark', N'kg'),
	(363, 353, N'Yougurt', N'l'),
	(405, 5, N'Pork', N'kg'),
	(568, 5, N'Chiken', N'kg')


INSERT INTO [KN304_Kapkaev].Kapkaev.Storage
  VALUES 
	(89, 1, '15-10-22 12:32', 80, 105, 0),
	(89, 2, '14-10-22 13:48', 75, 100, 1),
	(89, 3, '15-10-22 12:00', 90, 200, 5),

	(82, 1, '11-10-22 11:32', 50, 52, 3),
	(82, 3, '15-10-22 15:33', 48, 58, 10),
	(82, 4, '13-10-22 11:00', 39, 55, 5),

	(63, 2, '10-10-22 11:32', 60, 22, 3),
	(63, 3, '14-10-22 15:33', 70, 40, 1),

	(5, 1, '10-10-22 11:32', 25, 50, 3),
	(5, 2, '14-10-22 15:33', 22, 60, 1),
	(5, 4, '15-10-22 11:00', 30, 70, 8),

	(189, 1, '10-10-22 11:30', 60, 250, 13),
	(189, 2, '14-10-22 15:28', 70, 160, 11),
	(189, 3, '15-10-22 11:24', 65, 170, 28),
	(189, 4, '15-10-22 11:48', 63, 170, 18),

	(363, 1, '15-10-22 11:53', 28, 70, 0),
	(363, 4, '15-10-22 11:05', 30, 25, 8),

	(568, 1, '14-10-22 15:06', 220, 600, 10),
	(568, 3, '15-10-22 11:04', 300, 700, 80),
	(568, 4, '15-10-22 11:30', 307, 705, 84)

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
