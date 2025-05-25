--1.1
use X_NyBASE
exec SP_HELPINDEX'GroupCourses' --�������� ��������, ��������� � �������� ��������
--1.2 �������� ���������� 1000 �����
CREATE TABLE #TempProducts (
    ProductID INT IDENTITY(1,1) PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    Price DECIMAL(10,2),
    StockQuantity INT,
    LastUpdated DATETIME DEFAULT GETDATE()
);

DECLARE @i INT = 1;
WHILE @i <= 1000
BEGIN
    INSERT INTO #TempProducts (ProductName, Category, Price, StockQuantity)
    VALUES (
        'Product ' + CAST(@i AS VARCHAR(10)),
        CASE 
            WHEN @i % 5 = 0 THEN 'Electronics'
            WHEN @i % 5 = 1 THEN 'Clothing'
            WHEN @i % 5 = 2 THEN 'Home'
            WHEN @i % 5 = 3 THEN 'Sports'
            ELSE 'Food'
        END,
        ROUND((RAND() * 1000) + 10, 2),
        FLOOR(RAND() * 1000)
    );
    
    SET @i = @i + 1;
END

SELECT TOP 10 * FROM #TempProducts;
SELECT COUNT(*) AS TotalRows FROM #TempProducts;

--DROP TABLE #TempProducts;


--1.2 1� �����

CREATE TABLE #TempData (
    RowID INT IDENTITY(1,1),
    DataValue VARCHAR(50),
    LastUpdated DATETIME DEFAULT GETDATE()
);

DECLARE @i INT = 1;
WHILE @i <= 1000
BEGIN
    INSERT INTO #TempData (DataValue)
    VALUES ('Record ' + CAST(@i AS VARCHAR(10)));
    
    SET @i = @i + 1;
END

SELECT 
    RowID,
    DataValue,
    LastUpdated,
    CONVERT(VARCHAR(20), LastUpdated, 120) AS FormattedDateTime
FROM #TempData
ORDER BY RowID;

SELECT COUNT(*) AS TotalRows FROM #TempData;

CREATE clustered index #EXPLRE_CL on #TempData(RowID asc);

checkpoint; --��������
DBCC DROPCLEANBUFFERS; --������� ���� 

--DROP TABLE #TempProducts;


-- 2. �������� ������� ��� ������������ ������������������ ��������
CREATE TABLE #EX (
    TKEY INT,
    CC INT IDENTITY(1, 1),
    TF VARCHAR(100)
);

SET NOCOUNT ON;
DECLARE @i INT = 0;
WHILE @i < 20000 -- ���������� � ������� 20000 �����
BEGIN
    INSERT #EX(TKEY, TF)
    VALUES(FLOOR(30000*RAND()), REPLICATE('string ', 10));
    
    SET @i = @i + 1;
END;

SELECT COUNT(*) AS [���������� �����] FROM #EX;

-- �������� ���������� ������������������� �������
CREATE INDEX #EX_NONCLU ON #EX(TKEY, CC);

-- �������� ������������� �������
SELECT * FROM #EX WHERE TKEY > 1500 AND CC < 4500;
SELECT * FROM #EX ORDER BY TKEY, CC;
SELECT * FROM #EX WHERE TKEY = 556 AND CC > 3;


--DROP TABLE #EX

-- 3. �������� ������� ��������
CREATE INDEX #EX_TKEY_X ON #EX(TKEY) INCLUDE (CC);

-- �������� ������������� ������� ��������
SELECT CC FROM #EX WHERE TKEY > 15000;

-- 4. �������� ������������ �������
CREATE INDEX #EX_WHERE ON #EX(TKEY) WHERE (TKEY >= 15000 AND TKEY < 20000);

-- �������� ������������� ������������ �������
SELECT TKEY FROM #EX WHERE TKEY BETWEEN 5000 AND 19999;
SELECT TKEY FROM #EX WHERE TKEY > 15000 AND TKEY < 20000;
SELECT TKEY FROM #EX WHERE TKEY = 17000;

-- 5. ������ � ������������� �������
-- �������� ������� ��� ������������ ������������
CREATE INDEX #EX_TKEY ON #EX(TKEY);

-- �������� ������������ (������������ ������ ��� ��������� ������)
SELECT 
    OBJECT_NAME(i.object_id, DB_ID('tempdb')) AS TableName,
    i.name AS IndexName,
    ips.avg_fragmentation_in_percent
FROM 
    sys.dm_db_index_physical_stats(DB_ID('tempdb'), OBJECT_ID('tempdb..#EX'), NULL, NULL, NULL) ips
JOIN 
    tempdb.sys.indexes i ON ips.object_id = i.object_id AND ips.index_id = i.index_id
WHERE 
    i.name IS NOT NULL;

-- ���������� ������ ��� ���������� ������������
INSERT TOP(10000) #EX(TKEY, TF) SELECT TKEY, TF FROM #EX;

-- �������� ������������ ����� �������
SELECT 
    OBJECT_NAME(i.object_id, DB_ID('tempdb')) AS TableName,
    i.name AS IndexName,
    ips.avg_fragmentation_in_percent
FROM 
    sys.dm_db_index_physical_stats(DB_ID('tempdb'), OBJECT_ID('tempdb..#EX'), NULL, NULL, NULL) ips
JOIN 
    tempdb.sys.indexes i ON ips.object_id = i.object_id AND ips.index_id = i.index_id
WHERE 
    i.name IS NOT NULL;

-- ������������� �������
ALTER INDEX #EX_TKEY ON #EX REORGANIZE;

-- �������� ������������ ����� �������������
SELECT 
    OBJECT_NAME(i.object_id, DB_ID('tempdb')) AS TableName,
    i.name AS IndexName,
    ips.avg_fragmentation_in_percent
FROM 
    sys.dm_db_index_physical_stats(DB_ID('tempdb'), OBJECT_ID('tempdb..#EX'), NULL, NULL, NULL) ips
JOIN 
    tempdb.sys.indexes i ON ips.object_id = i.object_id AND ips.index_id = i.index_id
WHERE 
    i.name IS NOT NULL;

-- ����������� �������
ALTER INDEX #EX_TKEY ON #EX REBUILD WITH (ONLINE = OFF);

-- �������� ������������ ����� �����������
SELECT 
    OBJECT_NAME(i.object_id, DB_ID('tempdb')) AS TableName,
    i.name AS IndexName,
    ips.avg_fragmentation_in_percent
FROM 
    sys.dm_db_index_physical_stats(DB_ID('tempdb'), OBJECT_ID('tempdb..#EX'), NULL, NULL, NULL) ips
JOIN 
    tempdb.sys.indexes i ON ips.object_id = i.object_id AND ips.index_id = i.index_id
WHERE 
    i.name IS NOT NULL;

-- 6. ���������� ������������� � ������� FILLFACTOR
-- �������� � ������������ ������� � FILLFACTOR
DROP INDEX #EX_TKEY ON #EX;
CREATE INDEX #EX_TKEY ON #EX(TKEY) WITH (FILLFACTOR = 65);

-- ���������� ������ ��� �������� ������������
INSERT TOP(50) PERCENT INTO #EX(TKEY, TF) SELECT TKEY, TF FROM #EX;

-- �������� ������������
SELECT 
    OBJECT_NAME(i.object_id, DB_ID('tempdb')) AS TableName,
    i.name AS IndexName,
    ips.avg_fragmentation_in_percent
FROM 
    sys.dm_db_index_physical_stats(DB_ID('tempdb'), OBJECT_ID('tempdb..#EX'), NULL, NULL, NULL) ips
JOIN 
    tempdb.sys.indexes i ON ips.object_id = i.object_id AND ips.index_id = i.index_id
WHERE 
    i.name IS NOT NULL;
-- ������� ��������� ������
DROP TABLE #TempProducts;
DROP TABLE #TempData;
DROP TABLE #EX;