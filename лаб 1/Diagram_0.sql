/*
   24 февраля 2025 г.15:54:00
   Пользователь: 
   Сервер: (localdb)\MSSQLLocalDB
   База данных: БондарикПРОДАЖИ
   Приложение: 
*/

/* Чтобы предотвратить возможность потери данных, необходимо внимательно просмотреть этот скрипт, прежде чем запускать его вне контекста конструктора баз данных.*/
BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.ТОВАРЫ SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.ТОВАРЫ', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.ТОВАРЫ', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.ТОВАРЫ', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_ЗАКАЗЧИКИ
	(
	Наименование_фирмы nvarchar(20) NOT NULL,
	Адрес nvarchar(50) NULL,
	Расчетный_счёт nvarchar(15) NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_ЗАКАЗЧИКИ SET (LOCK_ESCALATION = TABLE)
GO
IF EXISTS(SELECT * FROM dbo.ЗАКАЗЧИКИ)
	 EXEC('INSERT INTO dbo.Tmp_ЗАКАЗЧИКИ (Наименование_фирмы, Адрес, Расчетный_счёт)
		SELECT Наименование_фирмы, Адрес, Расчетный_счёт FROM dbo.ЗАКАЗЧИКИ WITH (HOLDLOCK TABLOCKX)')
GO
DROP TABLE dbo.ЗАКАЗЧИКИ
GO
EXECUTE sp_rename N'dbo.Tmp_ЗАКАЗЧИКИ', N'ЗАКАЗЧИКИ', 'OBJECT' 
GO
ALTER TABLE dbo.ЗАКАЗЧИКИ ADD CONSTRAINT
	PK_ЗАКАЗЧИКИ PRIMARY KEY CLUSTERED 
	(
	Наименование_фирмы
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
COMMIT
select Has_Perms_By_Name(N'dbo.ЗАКАЗЧИКИ', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.ЗАКАЗЧИКИ', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.ЗАКАЗЧИКИ', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_ЗАКАЗЫ
	(
	Номер_заказа nvarchar(10) NOT NULL,
	Наименование_товара nvarchar(20) NULL,
	Цена_продажи real NULL,
	Количество int NULL,
	Дата_поставки date NULL,
	Заказчик nvarchar(20) NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_ЗАКАЗЫ SET (LOCK_ESCALATION = TABLE)
GO
IF EXISTS(SELECT * FROM dbo.ЗАКАЗЫ)
	 EXEC('INSERT INTO dbo.Tmp_ЗАКАЗЫ (Номер_заказа, Наименование_товара, Цена_продажи, Количество, Дата_поставки, Заказчик)
		SELECT Номер_заказа, Наименование_товара, Цена_продажи, Количество, Дата_поставки, Заказчик FROM dbo.ЗАКАЗЫ WITH (HOLDLOCK TABLOCKX)')
GO
DROP TABLE dbo.ЗАКАЗЫ
GO
EXECUTE sp_rename N'dbo.Tmp_ЗАКАЗЫ', N'ЗАКАЗЫ', 'OBJECT' 
GO
ALTER TABLE dbo.ЗАКАЗЫ ADD CONSTRAINT
	PK_ЗАКАЗЫ PRIMARY KEY CLUSTERED 
	(
	Номер_заказа
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.ЗАКАЗЫ ADD CONSTRAINT
	FK_ЗАКАЗЫ_ТОВАРЫ FOREIGN KEY
	(
	Наименование_товара
	) REFERENCES dbo.ТОВАРЫ
	(
	Наименование
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
COMMIT
