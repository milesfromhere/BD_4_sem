-- 1.1 
DECLARE 
    @char_var CHAR(10) = 'CHAR',
    @varchar_var VARCHAR(20) = 'VARCHAR',
    @date_var DATETIME,
    @time_var TIME,
    @int_var INT,
    @smallint_var SMALLINT,
    @tinyint_var TINYINT,
    @numeric_var NUMERIC(12,5);

-- 1.2
SET @date_var = GETDATE();
SET @time_var = CONVERT(TIME, GETDATE());
SET @int_var = 2147483647;  -- Максимальное значение для INT
SET @smallint_var = 32767;  -- Максимальное значение для SMALLINT

-- 1.3
SELECT 
    @tinyint_var = 255,  
    @numeric_var = 12345.67890;

-- 1.4 
SELECT 
    @char_var AS [CHAR],
    @varchar_var AS [VARCHAR],
    @date_var AS [DATETIME],
    @time_var AS [TIME],
    @int_var AS [INT],
    @smallint_var AS [SMALLINT];

-- 1.5
PRINT 'TINYINT: ' + CAST(@tinyint_var AS VARCHAR(3));
PRINT 'NUMERIC: ' + CAST(@numeric_var AS VARCHAR(20));

-- 1.6 
SELECT 
    SQL_VARIANT_PROPERTY(@char_var, 'BaseType') AS [CHAR Type],
    SQL_VARIANT_PROPERTY(@char_var, 'MaxLength') AS [CHAR Length],
    
    SQL_VARIANT_PROPERTY(@varchar_var, 'BaseType') AS [VARCHAR Type],
    SQL_VARIANT_PROPERTY(@varchar_var, 'MaxLength') AS [VARCHAR Length],
    
    SQL_VARIANT_PROPERTY(@numeric_var, 'Precision') AS [NUMERIC Precision],
    SQL_VARIANT_PROPERTY(@numeric_var, 'Scale') AS [NUMERIC Scale];




--2 Определяем общую вместимость аудиторий
DECLARE @TotalCapacity INT;
DECLARE @AuditoriumCount INT;
DECLARE @AvgCapacity DECIMAL(10,2);
DECLARE @BelowAvgCount INT;
DECLARE @BelowAvgPercent DECIMAL(5,2);

-- общая вместимость
SELECT 
    @TotalCapacity = SUM(Capacity),
    @AuditoriumCount = COUNT(*)
FROM TIMETABLE
WHERE Capacity IS NOT NULL;

IF @TotalCapacity > 100
BEGIN
-- средняя
    SELECT @AvgCapacity = AVG(CAST(Capacity AS DECIMAL(10,2)))
    FROM TIMETABLE
    WHERE Capacity IS NOT NULL;
   -- ниже среднего 
    SELECT @BelowAvgCount = COUNT(*)
    FROM TIMETABLE
    WHERE Capacity < @AvgCapacity AND Capacity IS NOT NULL;
    
    -- Процент 
    SET @BelowAvgPercent = (CAST(@BelowAvgCount AS DECIMAL(5,2)) * 100) / @AuditoriumCount;

    SELECT 
        @AuditoriumCount AS [Количество аудиторий],
        @AvgCapacity AS [Средняя вместимость],
        @BelowAvgCount AS [Аудиторий ниже средней],
        @BelowAvgPercent AS [Процент ниже средней];
END
ELSE
BEGIN
    SELECT @TotalCapacity AS [Общая вместимость аудиторий];
END


--3 глобальные переменные
SELECT TOP 5 * INTO #TempTable FROM TIMETABLE;
PRINT '- - - - - - - - - -';
PRINT '@@ROWCOUNT:    ' + CAST(@@ROWCOUNT AS VARCHAR(20));
--количество строк, обработанных последним запросом
PRINT '@@VERSION:     ' + @@VERSION;
--версия SQL Server
PRINT '@@SPID:        ' + CAST(@@SPID AS VARCHAR(10));
--идентификатор текущего процесса
PRINT '@@ERROR:       ' + CAST(@@ERROR AS VARCHAR(10));
--код последней ошибки, 0 = нет ошибки
PRINT '@@SERVERNAME:  ' + @@SERVERNAME;
--имя сервера
PRINT '@@TRANCOUNT:   ' + CAST(@@TRANCOUNT AS VARCHAR(10));
--уровень вложенности транзакций, 0 = нет активных транзакций
PRINT '@@FETCH_STATUS: ' + CAST(@@FETCH_STATUS AS VARCHAR(10));
--статус последнего FETCH: 0 = успешно, -1 = ошибка, -2 = строка отсутствует
PRINT '@@NESTLEVEL:   ' + CAST(@@NESTLEVEL AS VARCHAR(10));
--уровень вложенности текущего выполнения: 1 = основной уровень

GO 

DROP TABLE #TempTable;

--4.1 система

DECLARE @t FLOAT = 3;
DECLARE @x FLOAT = 4;
DECLARE @z FLOAT;

IF @t > @x
    SET @z = POWER(SIN(@t), 2);
ELSE IF @t < @x
    SET @z = 4 * (@t + @x);
ELSE
    SET @z = 1 - EXP(@x - 2);

PRINT 'z: ' + CAST(@z AS VARCHAR(20)); --ответ

--4.2 инициалы

DECLARE @FullName NVARCHAR(100) = 'Bondarik Nikita Dzmitrievich';
DECLARE @ShortName NVARCHAR(100);

DECLARE @Space1 INT = CHARINDEX(' ', @FullName);
DECLARE @Space2 INT = CHARINDEX(' ', @FullName, @Space1 + 1);

SET @ShortName = 
    LEFT(@FullName, @Space1 - 1) + ' ' +
    SUBSTRING(@FullName, @Space1 + 1, 1) + '. ' +
    CASE 
        WHEN @Space2 > 0 THEN SUBSTRING(@FullName, @Space2 + 1, 1) + '.'
        ELSE ''
    END;

PRINT 'FullName: ' + @FullName;
PRINT 'ShortName: ' + @ShortName;


--4.3 ближайшее др студента



CREATE TABLE #Students (
    StudentID INT PRIMARY KEY,
    FullName NVARCHAR(100),
    BirthDate DATE
);
INSERT INTO #Students VALUES
(1, 'Vovan', '2000-05-15'),
(2, 'Nikitos', '2001-06-22'),
(3, 'Egor', '1999-12-10'),
(4, 'Vlados', '2002-07-03'),
(5, 'Den4ik', '2001-07-18');

CREATE TABLE #BirthdayNextMonth (
    StudentID INT,
    FullName NVARCHAR(100),
    BirthDate DATE,
    Age INT
);

INSERT INTO #BirthdayNextMonth
SELECT 
    StudentID,
    FullName,
    BirthDate,
    DATEDIFF(YEAR, BirthDate, GETDATE()) - 
    CASE 
        WHEN DATEADD(YEAR, DATEDIFF(YEAR, BirthDate, GETDATE()), BirthDate) > GETDATE() 
        THEN 1 
        ELSE 0 
    END AS Age
FROM #Students
WHERE MONTH(BirthDate) = MONTH(DATEADD(MONTH, 1, GETDATE()));

SELECT * FROM #BirthdayNextMonth;

DROP TABLE #Students;
DROP TABLE #BirthdayNextMonth;

--4.4 день недели когда студенды сдавали бд




CREATE TABLE #Groups (
    GroupID INT PRIMARY KEY,
    GroupName NVARCHAR(50)
);

CREATE TABLE #Subjects (
    SubjectID INT PRIMARY KEY,
    SubjectName NVARCHAR(100)
);

CREATE TABLE #Exams (
    ExamID INT PRIMARY KEY,
    GroupID INT,
    SubjectID INT,
    ExamDate DATE
);

INSERT INTO #Groups VALUES
(1, 'IT-101'), (2, 'IT-102'), (3, 'PHYS-201');

INSERT INTO #Subjects VALUES
(1, 'Mathematics'), (2, 'Database Systems'), (3, 'Physics');

INSERT INTO #Exams VALUES
(1, 1, 2, '2023-11-15'), 
(2, 1, 1, '2023-11-16'),
(3, 2, 2, '2023-11-17'), 
(4, 3, 3, '2023-11-18');

CREATE TABLE #ExamDays (
    GroupName NVARCHAR(50),
    SubjectName NVARCHAR(100),
    ExamDate DATE,
    WeekDay NVARCHAR(20)
);

INSERT INTO #ExamDays
SELECT 
    g.GroupName,
    s.SubjectName,
    e.ExamDate,
    DATENAME(WEEKDAY, e.ExamDate) AS WeekDay
FROM #Exams e
JOIN #Groups g ON e.GroupID = g.GroupID
JOIN #Subjects s ON e.SubjectID = s.SubjectID
WHERE s.SubjectName = 'Database Systems' AND g.GroupName = 'IT-101';

SELECT * FROM #ExamDays;

DROP TABLE #Groups;
DROP TABLE #Subjects;
DROP TABLE #Exams;
DROP TABLE #ExamDays;


--5 if else
DECLARE @x INT = (SELECT COUNT(StudentCount) FROM Groups);

IF (SELECT COUNT(*) FROM Groups) > 3
BEGIN
    PRINT 'Group count is > 3';
    PRINT 'Count = ' + CAST(@x AS VARCHAR(10));
END
ELSE
BEGIN
    PRINT 'Group count is <= 3';
    PRINT 'Count = ' + CAST(@x AS VARCHAR(10));
END

--6 case
CREATE TABLE #Faculties (
    FacultyID INT PRIMARY KEY,
    FacultyName VARCHAR(50)
);

CREATE TABLE #Groups (
    GroupID INT PRIMARY KEY,
    GroupName VARCHAR(20),
    FacultyID INT
);

CREATE TABLE #Students (
    StudentID INT PRIMARY KEY,
    FullName VARCHAR(100),
    GroupID INT
);

CREATE TABLE #Exams (
    ExamID INT PRIMARY KEY,
    SubjectName VARCHAR(50),
    ExamDate DATE
);

CREATE TABLE #Grades (
    GradeID INT PRIMARY KEY,
    StudentID INT,
    ExamID INT,
    GradeValue INT
);

INSERT INTO #Faculties VALUES 
(1, 'Computer Science'),
(2, 'Engineering'),
(3, 'Mathematics');

INSERT INTO #Groups VALUES
(1, '9', 1),
(2, '8', 1),
(3, '7', 2),
(4, '6', 3);

INSERT INTO #Students VALUES
(1, 'Nikitos', 1),
(2, 'Vovan', 1),
(3, 'Vlados', 2),
(4, 'David', 3),
(5, 'Sanya', 4);

INSERT INTO #Exams VALUES
(1, 'Database Systems', '2023-06-15'),
(2, 'Programming', '2023-06-20'),
(3, 'Math', '2023-06-25');

INSERT INTO #Grades VALUES
(1, 1, 1, 5),
(2, 1, 2, 4),
(3, 2, 1, 3),
(4, 2, 2, 5),
(5, 3, 1, 2),
(6, 4, 3, 4),
(7, 5, 3, 5);

SELECT 
    s.FullName,
    e.SubjectName,
    g.GradeValue,
    CASE 
        WHEN g.GradeValue = 5 THEN 'God blessed'
        WHEN g.GradeValue = 4 THEN 'Good'
        WHEN g.GradeValue = 3 THEN 'Bad'
        WHEN g.GradeValue = 2 THEN 'Poor'
        ELSE 'Fail'
    END AS GradeDescription,
    CASE
        WHEN g.GradeValue >= 4 THEN 'Passed'
        ELSE 'Failed'
    END AS PassStatus
FROM #Grades g
JOIN #Students s ON g.StudentID = s.StudentID
JOIN #Groups gr ON s.GroupID = gr.GroupID
JOIN #Faculties f ON gr.FacultyID = f.FacultyID
JOIN #Exams e ON g.ExamID = e.ExamID
WHERE f.FacultyName = 'Computer Science'
ORDER BY s.FullName, e.SubjectName;

DROP TABLE #Grades;
DROP TABLE #Exams;
DROP TABLE #Students;
DROP TABLE #Groups;
DROP TABLE #Faculties;

--7 while

CREATE TABLE #Faculties (
    FacultyID INT PRIMARY KEY,
    FacultyName VARCHAR(50)
);

INSERT INTO #Faculties VALUES 
(1, 'Computer Science'),
(2, 'Engineering'),
(3, 'Mathematics');

DECLARE @y INT = (SELECT COUNT(*) FROM #Faculties);
DECLARE @i INT = 1;

WHILE @i <= @y
BEGIN
    IF @y > 2
    BEGIN
        PRINT 'Faculty count > 2: ' + CAST(@y AS VARCHAR(10));
    END
    ELSE
    BEGIN
        PRINT 'Faculty count <= 2: ' + CAST(@y AS VARCHAR(10));
    END
    SET @i = @i + 1;
END

DROP TABLE #Faculties;

--8 return
DECLARE @qwe int=1 
print @qwe+1
return --Оператор RETURN служит для немедленного завершения работы пакета: 
print @qwe+3
print @qwe

--9 try/catch

BEGIN TRY
    CREATE TABLE #TestTable (
        ID INT PRIMARY KEY,
        Value VARCHAR(10)
    );
    
    INSERT INTO #TestTable VALUES (1, 'Valid');
    INSERT INTO #TestTable VALUES (1, 'Duplicate');
    
    SELECT 1/0;
    
    DROP TABLE #TestTable;
END TRY
BEGIN CATCH
    SELECT 
        ERROR_NUMBER() AS ErrorNumber,
        ERROR_MESSAGE() AS ErrorMessage,
        ERROR_LINE() AS ErrorLine,
        ERROR_PROCEDURE() AS ErrorProcedure,
        ERROR_SEVERITY() AS ErrorSeverity,
        ERROR_STATE() AS ErrorState;
    
    IF OBJECT_ID('tempdb..#TestTable') IS NOT NULL
        DROP TABLE #TestTable;
END CATCH;