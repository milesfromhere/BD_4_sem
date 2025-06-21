--лаб 15

CREATE DATABASE TempLab15;
GO

USE TempLab15;
GO

CREATE TABLE Товары (
    Наименование VARCHAR(50) PRIMARY KEY,
    Цена DECIMAL(10, 2),
    Количество INT
);

CREATE TABLE TR_Tov (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    ST VARCHAR(3),  -- Тип события (INS, DEL, UPD)
    TRN VARCHAR(50), -- Имя триггера
    C VARCHAR(300)   -- Данные о изменении
);

-- 2. Создание AFTER-триггера для INSERT
CREATE TRIGGER TRIG_Tov_Ins ON Товары
AFTER INSERT
AS
BEGIN
    DECLARE @name VARCHAR(50), @price DECIMAL(10, 2), @quantity INT;
    
    SELECT @name = Наименование, @price = Цена, @quantity = Количество 
    FROM INSERTED;
    
    INSERT INTO TR_Tov (ST, TRN, C)
    VALUES ('INS', 'TRIG_Tov_Ins', 
           @name + ' ' + CAST(@price AS VARCHAR) + ' ' + CAST(@quantity AS VARCHAR));
END;
GO

INSERT INTO Товары(Наименование, Цена, Количество)
VALUES ('Laptop', 140, 20);

SELECT * FROM TR_Tov;
GO

-- 3. Создание AFTER-триггера для DELETE
CREATE TRIGGER TR_TEACHER_DEL ON Товары
AFTER DELETE
AS
BEGIN
    DECLARE @name VARCHAR(50), @price DECIMAL(10, 2), @quantity INT;
    
    SELECT @name = Наименование, @price = Цена, @quantity = Количество 
    FROM DELETED;
    
    INSERT INTO TR_Tov (ST, TRN, C)
    VALUES ('DEL', 'TR_TEACHER_DEL', 
           @name + ' ' + CAST(@price AS VARCHAR) + ' ' + CAST(@quantity AS VARCHAR));
END;
GO

DELETE FROM Товары WHERE Наименование = 'Laptop';

SELECT * FROM TR_Tov;
GO

-- 4. Создание AFTER-триггера для UPDATE
CREATE TRIGGER TR_TEACHER_UPD ON Товары
AFTER UPDATE
AS
BEGIN
    DECLARE @name_old VARCHAR(50), @price_old DECIMAL(10, 2), @quantity_old INT;
    DECLARE @name_new VARCHAR(50), @price_new DECIMAL(10, 2), @quantity_new INT;
    DECLARE @info VARCHAR(500);
    
    SELECT @name_old = Наименование, @price_old = Цена, @quantity_old = Количество 
    FROM DELETED;
    
    SELECT @name_new = Наименование, @price_new = Цена, @quantity_new = Количество 
    FROM INSERTED;
    
    SET @info = @name_old + ' ' + CAST(@price_old AS VARCHAR) + ' ' + CAST(@quantity_old AS VARCHAR) + 
                ' -> ' + @name_new + ' ' + CAST(@price_new AS VARCHAR) + ' ' + CAST(@quantity_new AS VARCHAR);
    
    INSERT INTO TR_Tov (ST, TRN, C)
    VALUES ('UPD', 'TR_TEACHER_UPD', @info);
END;
GO

INSERT INTO Товары(Наименование, Цена, Количество) VALUES ('chair', 50, 10);
UPDATE Товары SET Количество = 20 WHERE Наименование = 'chair';

SELECT * FROM TR_Tov;
GO

-- 5. Создание универсального триггера для всех операций
CREATE TRIGGER TRIG_Tov ON Товары
AFTER INSERT, DELETE, UPDATE
AS
BEGIN
    DECLARE @a1 VARCHAR(20), @a2 DECIMAL(10, 2), @a3 INT, @in VARCHAR(300);
    DECLARE @ins INT = (SELECT COUNT(*) FROM inserted);
    DECLARE @del INT = (SELECT COUNT(*) FROM deleted);
    
    IF @ins > 0 AND @del = 0
    BEGIN
        PRINT 'INSERT';
        SET @a1 = (SELECT Наименование FROM INSERTED);
        SET @a2 = (SELECT Цена FROM INSERTED);
        SET @a3 = (SELECT Количество FROM INSERTED);
        SET @in = @a1 + ' ' + CAST(@a2 AS VARCHAR(20)) + ' ' + CAST(@a3 AS VARCHAR(20));
        
        INSERT INTO TR_Tov(ST, TRN, C) VALUES('INS', 'TRIG_Tov', @in);
    END;
    ELSE IF @ins = 0 AND @del > 0
    BEGIN
        PRINT 'DELETE';
        SET @a1 = (SELECT Наименование FROM deleted);
        SET @a2 = (SELECT Цена FROM deleted);
        SET @a3 = (SELECT Количество FROM deleted);
        SET @in = @a1 + ' ' + CAST(@a2 AS VARCHAR(20)) + ' ' + CAST(@a3 AS VARCHAR(20));
        
        INSERT INTO TR_Tov(ST, TRN, C) VALUES('DEL', 'TRIG_Tov', @in);
    END;
    ELSE IF @ins > 0 AND @del > 0
    BEGIN
        PRINT 'UPDATE';
        SET @a1 = (SELECT Наименование FROM inserted);
        SET @a2 = (SELECT Цена FROM inserted);
        SET @a3 = (SELECT Количество FROM inserted);
        SET @in = @a1 + ' ' + CAST(@a2 AS VARCHAR(20)) + ' ' + CAST(@a3 AS VARCHAR(20));
        
        SET @a1 = (SELECT Наименование FROM deleted);
        SET @a2 = (SELECT Цена FROM deleted);
        SET @a3 = (SELECT Количество FROM deleted);
        SET @in = @a1 + ' ' + CAST(@a2 AS VARCHAR(20)) + ' ' + CAST(@a3 AS VARCHAR(20)) + ' -> ' + @in;
        
        INSERT INTO TR_Tov(ST, TRN, C) VALUES('UPD', 'TRIG_Tov', @in);
    END;
    RETURN;
END;
GO

INSERT INTO Товары(Наименование, Цена, Количество) VALUES ('Table', 140, 20);
DELETE FROM Товары WHERE Наименование = 'Table';
UPDATE Товары SET Количество = 30 WHERE Наименование = 'chair';

SELECT * FROM TR_Tov;
GO

-- 6. Проверка ограничений целостности
ALTER TABLE Товары ADD CONSTRAINT Цена CHECK(Цена >= 15);
GO

-- Попытка нарушения ограничения (не сработает)
UPDATE Товары SET Цена = 10 WHERE Наименование = 'chair';
GO

CREATE TRIGGER AUD_AFTER_UPDA ON Товары AFTER UPDATE AS PRINT 'AUD_AFTER_UPDATE_A'; RETURN;
GO
CREATE TRIGGER AUD_AFTER_UPDB ON Товары AFTER UPDATE AS PRINT 'AUD_AFTER_UPDATE_B'; RETURN;
GO
CREATE TRIGGER AUD_AFTER_UPDC ON Товары AFTER UPDATE AS PRINT 'AUD_AFTER_UPDATE_C'; RETURN;
GO

SELECT t.name, e.type_desc
FROM sys.triggers t JOIN sys.trigger_events e
ON t.object_id = e.object_id
WHERE OBJECT_NAME(t.parent_id) = 'Items' AND e.type_desc = 'UPDATE';

-- Изменение порядка выполнения триггеров
EXEC SP_SETTRIGGERORDER @triggername = 'AUD_AFTER_UPDC', @order = 'First', @stmttype = 'UPDATE';
EXEC SP_SETTRIGGERORDER @triggername = 'AUD_AFTER_UPDA', @order = 'Last', @stmttype = 'UPDATE';
GO

-- 8. Триггер, ограничивающий общее количество товаров
CREATE TRIGGER TR_LIMIT ON Товары
AFTER INSERT, UPDATE
AS
BEGIN
    DECLARE @total INT;
    SELECT @total = SUM(Количество) FROM Товары;
    
    IF @total > 2000
    BEGIN
        RAISERROR('Total > 2000', 16, 1);
        ROLLBACK;
    END;
END;
GO

-- Попытка превысить лимит (не сработает)
UPDATE Товары SET Количество = 1990 WHERE Наименование = 'chair';
GO

-- 9. INSTEAD OF-триггер, запрещающий удаление
CREATE TRIGGER TR_NO_DELETE ON Товары
INSTEAD OF DELETE
AS
BEGIN
    RAISERROR('Deleted!', 16, 1);
    RETURN;
END;
GO

-- Попытка удаления (не сработает)
DELETE FROM Товары WHERE Наименование = 'chair';
GO

-- 10. DDL-триггер, запрещающий изменения в базе данных
CREATE TRIGGER DDL_PRODAJI ON DATABASE
FOR DDL_DATABASE_LEVEL_EVENTS
AS
BEGIN
    DECLARE @t VARCHAR(50) = EVENTDATA().value('(/EVENT_INSTANCE/EventType)[1]', 'varchar(50)');
    DECLARE @t1 VARCHAR(50) = EVENTDATA().value('(/EVENT_INSTANCE/ObjectName)[1]', 'varchar(50)');
    DECLARE @t2 VARCHAR(50) = EVENTDATA().value('(/EVENT_INSTANCE/ObjectType)[1]', 'varchar(50)');
    
    IF @t1 = 'Items'
    BEGIN
        PRINT 'Type: ' + @t;
        PRINT 'Name: ' + @t1;
        PRINT 'Object Type: ' + @t2;
        RAISERROR('Rejected!', 16, 1);
        ROLLBACK;
    END;
END;
GO

-- Попытка изменения таблицы (не сработает)
ALTER TABLE Товары DROP COLUMN Количество;
GO

-- 11. Создание таблицы WEATHER и триггера для проверки временных периодов
CREATE TABLE WEATHER (
    Город VARCHAR(50),
    НачальнаяДата DATETIME,
    КонечнаяДата DATETIME,
    Температура INT,
    PRIMARY KEY (Город, НачальнаяДата, КонечнаяДата)
);
GO

CREATE TRIGGER TR_WEATHER ON WEATHER
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1 FROM inserted i
        JOIN WEATHER w ON i.Город = w.Город
        WHERE (
            (i.НачальнаяДата BETWEEN w.НачальнаяДата AND w.КонечнаяДата) OR
            (i.КонечнаяДата BETWEEN w.НачальнаяДата AND w.КонечнаяДата) OR
            (w.НачальнаяДата BETWEEN i.НачальнаяДата AND i.КонечнаяДата) OR
            (w.КонечнаяДата BETWEEN i.НачальнаяДата AND i.КонечнаяДата)
        )
        AND NOT (i.Город = w.Город AND i.НачальнаяДата = w.НачальнаяДата AND i.КонечнаяДата = w.КонечнаяДата)
    )
    BEGIN
        RAISERROR('Error!', 16, 1);
        ROLLBACK;
    END;
END;
GO

INSERT INTO WEATHER VALUES ('Minsk', '2022-01-01 00:00', '2022-01-01 23:59', -6);

INSERT INTO WEATHER VALUES ('Minsk', '2022-01-01 12:00', '2022-01-02 12:00', -2);
GO
USE master;
GO
DROP DATABASE TempLab15;
GO