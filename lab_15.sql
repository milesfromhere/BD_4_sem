--��� 15

CREATE DATABASE TempLab15;
GO

USE TempLab15;
GO

CREATE TABLE ������ (
    ������������ VARCHAR(50) PRIMARY KEY,
    ���� DECIMAL(10, 2),
    ���������� INT
);

CREATE TABLE TR_Tov (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    ST VARCHAR(3),  -- ��� ������� (INS, DEL, UPD)
    TRN VARCHAR(50), -- ��� ��������
    C VARCHAR(300)   -- ������ � ���������
);

-- 2. �������� AFTER-�������� ��� INSERT
CREATE TRIGGER TRIG_Tov_Ins ON ������
AFTER INSERT
AS
BEGIN
    DECLARE @name VARCHAR(50), @price DECIMAL(10, 2), @quantity INT;
    
    SELECT @name = ������������, @price = ����, @quantity = ���������� 
    FROM INSERTED;
    
    INSERT INTO TR_Tov (ST, TRN, C)
    VALUES ('INS', 'TRIG_Tov_Ins', 
           @name + ' ' + CAST(@price AS VARCHAR) + ' ' + CAST(@quantity AS VARCHAR));
END;
GO

INSERT INTO ������(������������, ����, ����������)
VALUES ('Laptop', 140, 20);

SELECT * FROM TR_Tov;
GO

-- 3. �������� AFTER-�������� ��� DELETE
CREATE TRIGGER TR_TEACHER_DEL ON ������
AFTER DELETE
AS
BEGIN
    DECLARE @name VARCHAR(50), @price DECIMAL(10, 2), @quantity INT;
    
    SELECT @name = ������������, @price = ����, @quantity = ���������� 
    FROM DELETED;
    
    INSERT INTO TR_Tov (ST, TRN, C)
    VALUES ('DEL', 'TR_TEACHER_DEL', 
           @name + ' ' + CAST(@price AS VARCHAR) + ' ' + CAST(@quantity AS VARCHAR));
END;
GO

DELETE FROM ������ WHERE ������������ = 'Laptop';

SELECT * FROM TR_Tov;
GO

-- 4. �������� AFTER-�������� ��� UPDATE
CREATE TRIGGER TR_TEACHER_UPD ON ������
AFTER UPDATE
AS
BEGIN
    DECLARE @name_old VARCHAR(50), @price_old DECIMAL(10, 2), @quantity_old INT;
    DECLARE @name_new VARCHAR(50), @price_new DECIMAL(10, 2), @quantity_new INT;
    DECLARE @info VARCHAR(500);
    
    SELECT @name_old = ������������, @price_old = ����, @quantity_old = ���������� 
    FROM DELETED;
    
    SELECT @name_new = ������������, @price_new = ����, @quantity_new = ���������� 
    FROM INSERTED;
    
    SET @info = @name_old + ' ' + CAST(@price_old AS VARCHAR) + ' ' + CAST(@quantity_old AS VARCHAR) + 
                ' -> ' + @name_new + ' ' + CAST(@price_new AS VARCHAR) + ' ' + CAST(@quantity_new AS VARCHAR);
    
    INSERT INTO TR_Tov (ST, TRN, C)
    VALUES ('UPD', 'TR_TEACHER_UPD', @info);
END;
GO

INSERT INTO ������(������������, ����, ����������) VALUES ('chair', 50, 10);
UPDATE ������ SET ���������� = 20 WHERE ������������ = 'chair';

SELECT * FROM TR_Tov;
GO

-- 5. �������� �������������� �������� ��� ���� ��������
CREATE TRIGGER TRIG_Tov ON ������
AFTER INSERT, DELETE, UPDATE
AS
BEGIN
    DECLARE @a1 VARCHAR(20), @a2 DECIMAL(10, 2), @a3 INT, @in VARCHAR(300);
    DECLARE @ins INT = (SELECT COUNT(*) FROM inserted);
    DECLARE @del INT = (SELECT COUNT(*) FROM deleted);
    
    IF @ins > 0 AND @del = 0
    BEGIN
        PRINT 'INSERT';
        SET @a1 = (SELECT ������������ FROM INSERTED);
        SET @a2 = (SELECT ���� FROM INSERTED);
        SET @a3 = (SELECT ���������� FROM INSERTED);
        SET @in = @a1 + ' ' + CAST(@a2 AS VARCHAR(20)) + ' ' + CAST(@a3 AS VARCHAR(20));
        
        INSERT INTO TR_Tov(ST, TRN, C) VALUES('INS', 'TRIG_Tov', @in);
    END;
    ELSE IF @ins = 0 AND @del > 0
    BEGIN
        PRINT 'DELETE';
        SET @a1 = (SELECT ������������ FROM deleted);
        SET @a2 = (SELECT ���� FROM deleted);
        SET @a3 = (SELECT ���������� FROM deleted);
        SET @in = @a1 + ' ' + CAST(@a2 AS VARCHAR(20)) + ' ' + CAST(@a3 AS VARCHAR(20));
        
        INSERT INTO TR_Tov(ST, TRN, C) VALUES('DEL', 'TRIG_Tov', @in);
    END;
    ELSE IF @ins > 0 AND @del > 0
    BEGIN
        PRINT 'UPDATE';
        SET @a1 = (SELECT ������������ FROM inserted);
        SET @a2 = (SELECT ���� FROM inserted);
        SET @a3 = (SELECT ���������� FROM inserted);
        SET @in = @a1 + ' ' + CAST(@a2 AS VARCHAR(20)) + ' ' + CAST(@a3 AS VARCHAR(20));
        
        SET @a1 = (SELECT ������������ FROM deleted);
        SET @a2 = (SELECT ���� FROM deleted);
        SET @a3 = (SELECT ���������� FROM deleted);
        SET @in = @a1 + ' ' + CAST(@a2 AS VARCHAR(20)) + ' ' + CAST(@a3 AS VARCHAR(20)) + ' -> ' + @in;
        
        INSERT INTO TR_Tov(ST, TRN, C) VALUES('UPD', 'TRIG_Tov', @in);
    END;
    RETURN;
END;
GO

INSERT INTO ������(������������, ����, ����������) VALUES ('Table', 140, 20);
DELETE FROM ������ WHERE ������������ = 'Table';
UPDATE ������ SET ���������� = 30 WHERE ������������ = 'chair';

SELECT * FROM TR_Tov;
GO

-- 6. �������� ����������� �����������
ALTER TABLE ������ ADD CONSTRAINT ���� CHECK(���� >= 15);
GO

-- ������� ��������� ����������� (�� ���������)
UPDATE ������ SET ���� = 10 WHERE ������������ = 'chair';
GO

CREATE TRIGGER AUD_AFTER_UPDA ON ������ AFTER UPDATE AS PRINT 'AUD_AFTER_UPDATE_A'; RETURN;
GO
CREATE TRIGGER AUD_AFTER_UPDB ON ������ AFTER UPDATE AS PRINT 'AUD_AFTER_UPDATE_B'; RETURN;
GO
CREATE TRIGGER AUD_AFTER_UPDC ON ������ AFTER UPDATE AS PRINT 'AUD_AFTER_UPDATE_C'; RETURN;
GO

SELECT t.name, e.type_desc
FROM sys.triggers t JOIN sys.trigger_events e
ON t.object_id = e.object_id
WHERE OBJECT_NAME(t.parent_id) = 'Items' AND e.type_desc = 'UPDATE';

-- ��������� ������� ���������� ���������
EXEC SP_SETTRIGGERORDER @triggername = 'AUD_AFTER_UPDC', @order = 'First', @stmttype = 'UPDATE';
EXEC SP_SETTRIGGERORDER @triggername = 'AUD_AFTER_UPDA', @order = 'Last', @stmttype = 'UPDATE';
GO

-- 8. �������, �������������� ����� ���������� �������
CREATE TRIGGER TR_LIMIT ON ������
AFTER INSERT, UPDATE
AS
BEGIN
    DECLARE @total INT;
    SELECT @total = SUM(����������) FROM ������;
    
    IF @total > 2000
    BEGIN
        RAISERROR('Total > 2000', 16, 1);
        ROLLBACK;
    END;
END;
GO

-- ������� ��������� ����� (�� ���������)
UPDATE ������ SET ���������� = 1990 WHERE ������������ = 'chair';
GO

-- 9. INSTEAD OF-�������, ����������� ��������
CREATE TRIGGER TR_NO_DELETE ON ������
INSTEAD OF DELETE
AS
BEGIN
    RAISERROR('Deleted!', 16, 1);
    RETURN;
END;
GO

-- ������� �������� (�� ���������)
DELETE FROM ������ WHERE ������������ = 'chair';
GO

-- 10. DDL-�������, ����������� ��������� � ���� ������
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

-- ������� ��������� ������� (�� ���������)
ALTER TABLE ������ DROP COLUMN ����������;
GO

-- 11. �������� ������� WEATHER � �������� ��� �������� ��������� ��������
CREATE TABLE WEATHER (
    ����� VARCHAR(50),
    ������������� DATETIME,
    ������������ DATETIME,
    ����������� INT,
    PRIMARY KEY (�����, �������������, ������������)
);
GO

CREATE TRIGGER TR_WEATHER ON WEATHER
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1 FROM inserted i
        JOIN WEATHER w ON i.����� = w.�����
        WHERE (
            (i.������������� BETWEEN w.������������� AND w.������������) OR
            (i.������������ BETWEEN w.������������� AND w.������������) OR
            (w.������������� BETWEEN i.������������� AND i.������������) OR
            (w.������������ BETWEEN i.������������� AND i.������������)
        )
        AND NOT (i.����� = w.����� AND i.������������� = w.������������� AND i.������������ = w.������������)
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