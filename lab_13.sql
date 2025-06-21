--1. Процедура для подсчета количества строк в таблице Groups и вывода ее содержимого
CREATE PROCEDURE CountGroups 
AS
BEGIN
    DECLARE @count INT;
    SELECT @count = COUNT(*) FROM Groups;
    PRINT 'Groups: ' + CAST(@count AS VARCHAR(10));
    SELECT * FROM Groups;
END;
GO

EXEC CountGroups;


--2. Процедура с входными и выходными 
CREATE PROCEDURE GetTeachersByExperience
    @minExperience INT,
    @teacherCount INT OUTPUT
AS
BEGIN
    SELECT @teacherCount = COUNT(*) 
    FROM Teachers 
    WHERE Experience >= @minExperience;
    
    PRINT 'Expirience is over at' + CAST(@minExperience AS VARCHAR(3)) + ' years:';
    SELECT TeacherID, LastName, FirstName, Experience 
    FROM Teachers 
    WHERE Experience >= @minExperience
    ORDER BY Experience DESC;
END;
GO

DECLARE @count INT;
EXEC GetTeachersByExperience @minExperience = 7, @teacherCount = @count OUTPUT;
PRINT 'Teacher is fiend: ' + CAST(@count AS VARCHAR(3));

--3. Процедура для работы с временными таблицами 
CREATE PROCEDURE GetGroupsByDepartment
    @department NVARCHAR(100)
AS
BEGIN
    SELECT GroupNumber, Speciality, StudentCount 
    FROM Groups 
    WHERE Department = @department;
END;
GO

CREATE TABLE #TechGroups (GroupNumber NVARCHAR(50), Speciality NVARCHAR(100), Students INT);

INSERT INTO #TechGroups
EXEC GetGroupsByDepartment @department = 'Technical Department';

SELECT * FROM #TechGroups;
DROP TABLE #TechGroups;


--4. Процедура с обработкой ошибок для вставки данных в таблицу Courses
CREATE PROCEDURE InsertCourse
    @name NVARCHAR(100),
    @hours INT,
    @subject NVARCHAR(100),
    @type NVARCHAR(50),
    @payment DECIMAL(10,2),
    @result INT OUTPUT
AS
BEGIN
    SET @result = 0;
    BEGIN TRY
        INSERT INTO Courses (CourseName, Hours, Subject, LessonType, Payment)
        VALUES (@name, @hours, @subject, @type, @payment);
        SET @result = 1;
    END TRY
    BEGIN CATCH
        PRINT 'Error:';
        PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS VARCHAR(10));
        PRINT 'Message: ' + ERROR_MESSAGE();
        PRINT 'Level: ' + CAST(ERROR_SEVERITY() AS VARCHAR(10));
        PRINT 'State: ' + CAST(ERROR_STATE() AS VARCHAR(10));
        PRINT 'line: ' + CAST(ERROR_LINE() AS VARCHAR(10));
        IF ERROR_PROCEDURE() IS NOT NULL
            PRINT 'Procedure: ' + ERROR_PROCEDURE();
    END CATCH
END;
GO

DECLARE @res INT;
EXEC InsertCourse 
    @name = 'Database Systems', 
    @hours = 110, 
    @subject = 'Computer Science', 
    @type = 'Lecture', 
    @payment = 5500.00,
    @result = @res OUTPUT;
PRINT 'Result: ' + CASE WHEN @res = 1 THEN 'Done' ELSE 'Error' END;


--5. Процедура для формирования отчета о расписании группы с использованием курсора
CREATE PROCEDURE GroupTimetableReport
    @groupNumber NVARCHAR(50)
AS
BEGIN
    DECLARE @groupID INT, @groupName NVARCHAR(100);
    DECLARE @day NVARCHAR(15), @lesson INT, @course NVARCHAR(100), @teacher NVARCHAR(100), @auditorium NVARCHAR(20);
    DECLARE @report NVARCHAR(MAX) = '';
    
    SELECT @groupID = GroupID, @groupName = GroupNumber + ' (' + Speciality + ')'
    FROM Groups 
    WHERE GroupNumber = @groupNumber;
    
    IF @groupID IS NULL
    BEGIN
        RAISERROR('Group Number %s Not Found', 11, 1, @groupNumber);
        RETURN -1;
    END
    
    PRINT 'Raspisanie: ' + @groupName;
    PRINT '--------------------------------';
    
    DECLARE timetable_cursor CURSOR FOR
    SELECT t.DayOfWeek, t.LessonNumber, c.CourseName, 
           te.LastName + ' ' + te.FirstName AS Teacher, t.Auditorium
    FROM TIMETABLE t
    JOIN Courses c ON t.CourseID = c.CourseID
    JOIN Teachers te ON t.TeacherID = te.TeacherID
    WHERE t.GroupID = @groupID
    ORDER BY 
        CASE t.DayOfWeek
            WHEN 'Monday' THEN 1
            WHEN 'Tuesday' THEN 2
            WHEN 'Wednesday' THEN 3
            WHEN 'Thursday' THEN 4
            WHEN 'Friday' THEN 5
            WHEN 'Saturday' THEN 6
            WHEN 'Sunday' THEN 7
            ELSE 8
        END,
        t.LessonNumber;
    
    OPEN timetable_cursor;
    FETCH NEXT FROM timetable_cursor INTO @day, @lesson, @course, @teacher, @auditorium;
    
    WHILE @@FETCH_STATUS = 0
    BEGIN
        SET @report = @report + @day + ', PARA ' + CAST(@lesson AS VARCHAR(2)) + 
                     ': ' + @course + ' (' + @teacher + '), ауд. ' + @auditorium + CHAR(13) + CHAR(10);
        FETCH NEXT FROM timetable_cursor INTO @day, @lesson, @course, @teacher, @auditorium;
    END
    
    CLOSE timetable_cursor;
    DEALLOCATE timetable_cursor;
    
    PRINT @report;
    RETURN 0;
END;
GO

DECLARE @rc INT;
EXEC @rc = GroupTimetableReport @groupNumber = 'G101';
PRINT 'Error Code: ' + CAST(@rc AS VARCHAR(2));


--6. Комплексная процедура для добавления данных в несколько таблиц с транзакцией
CREATE PROCEDURE AddGroupCourse
    @groupNumber NVARCHAR(50),
    @courseName NVARCHAR(100),
    @teacherLastName NVARCHAR(50),
    @dayOfWeek NVARCHAR(15),
    @lessonNumber INT,
    @auditorium NVARCHAR(20),
    @result INT OUTPUT
AS
BEGIN
    SET @result = 0;
    DECLARE @groupID INT, @courseID INT, @teacherID INT;
    
    BEGIN TRY
        SELECT @groupID = GroupID FROM Groups WHERE GroupNumber = @groupNumber;
        IF @groupID IS NULL
        BEGIN
            RAISERROR('%s Not Found', 11, 1, @groupNumber);
            RETURN -1;
        END
        
        SELECT @courseID = CourseID FROM Courses WHERE CourseName = @courseName;
        IF @courseID IS NULL
        BEGIN
            RAISERROR('%s Not Found', 11, 1, @courseName);
            RETURN -2;
        END
        
        SELECT @teacherID = TeacherID FROM Teachers WHERE LastName = @teacherLastName;
        IF @teacherID IS NULL
        BEGIN
            RAISERROR('Gross Name %s Not Found', 11, 1, @teacherLastName);
            RETURN -3;
        END
        
        SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
        BEGIN TRANSACTION;
        
        IF NOT EXISTS (SELECT 1 FROM GroupCourses WHERE GroupID = @groupID AND CourseID = @courseID)
        BEGIN
            INSERT INTO GroupCourses (GroupID, CourseID, TeacherID)
            VALUES (@groupID, @courseID, @teacherID);
        END
        
        INSERT INTO TIMETABLE (GroupID, CourseID, TeacherID, DayOfWeek, LessonNumber, Auditorium)
        VALUES (@groupID, @courseID, @teacherID, @dayOfWeek, @lessonNumber, @auditorium);
        
        COMMIT TRANSACTION;
        
        SET @result = 1;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        
        PRINT 'Error:';
        PRINT 'Number: ' + CAST(ERROR_NUMBER() AS VARCHAR(10));
        PRINT 'Message: ' + ERROR_MESSAGE();
        PRINT 'Level: ' + CAST(ERROR_SEVERITY() AS VARCHAR(10));
        PRINT 'State: ' + CAST(ERROR_STATE() AS VARCHAR(10));
        PRINT 'Line: ' + CAST(ERROR_LINE() AS VARCHAR(10));
        IF ERROR_PROCEDURE() IS NOT NULL
            PRINT 'Procedure: ' + ERROR_PROCEDURE();
    END CATCH
END;
GO

DECLARE @res INT;
EXEC AddGroupCourse 
    @groupNumber = 'G101',
    @courseName = 'Python Programming',
    @teacherLastName = 'Smith',
    @dayOfWeek = 'Monday',
    @lessonNumber = 3,
    @auditorium = 'A101',
    @result = @res OUTPUT;
    
PRINT 'Result: ' + CASE WHEN @res = 1 THEN 'Done' ELSE 'Error' END;


--7. Процедура PRINT_REPORT для формирования отчета 
CREATE PROCEDURE PRINT_REPORT
    @f NVARCHAR(10) = NULL,  -- (Department)
    @p NVARCHAR(10) = NULL   -- (Speciality)
AS
BEGIN
    DECLARE @pulpits TABLE (Department NVARCHAR(100), Speciality NVARCHAR(100));
    DECLARE @count INT = 0;
    
    BEGIN TRY
        IF @f IS NULL AND @p IS NOT NULL
        BEGIN
            SELECT @f = Department 
            FROM Groups 
            WHERE Speciality = @p;
            
            IF @f IS NULL
            BEGIN
                RAISERROR('Error. Not Found %s', 11, 1, @p);
                RETURN -1;
            END
        END
        
        PRINT 'Result:';
        PRINT '----------------';
        
        IF @f IS NOT NULL AND @p IS NULL
        BEGIN
            PRINT 'facultet: ' + @f;
            PRINT '';
            
            SELECT g.GroupNumber, g.Speciality, g.StudentCount,
                   STRING_AGG(c.CourseName, ', ') AS Courses,
                   STRING_AGG(t.LastName + ' ' + t.FirstName, ', ') AS Teachers
            FROM Groups g
            LEFT JOIN GroupCourses gc ON g.GroupID = gc.GroupID
            LEFT JOIN Courses c ON gc.CourseID = c.CourseID
            LEFT JOIN Teachers t ON gc.TeacherID = t.TeacherID
            WHERE g.Department = @f
            GROUP BY g.GroupNumber, g.Speciality, g.StudentCount
            ORDER BY g.GroupNumber;
            
            SELECT @count = COUNT(*) FROM Groups WHERE Department = @f;
        END
        ELSE IF @f IS NOT NULL AND @p IS NOT NULL
        BEGIN
            -- Отчет для кафедры факультета
            PRINT 'facultet: ' + @f;
            PRINT 'kafedra: ' + @p;
            PRINT '';
            
            SELECT g.GroupNumber, g.StudentCount,
                   STRING_AGG(c.CourseName, ', ') AS Courses,
                   STRING_AGG(t.LastName + ' ' + t.FirstName, ', ') AS Teachers
            FROM Groups g
            LEFT JOIN GroupCourses gc ON g.GroupID = gc.GroupID
            LEFT JOIN Courses c ON gc.CourseID = c.CourseID
            LEFT JOIN Teachers t ON gc.TeacherID = t.TeacherID
            WHERE g.Department = @f AND g.Speciality = @p
            GROUP BY g.GroupNumber, g.StudentCount
            ORDER BY g.GroupNumber;
            
            SELECT @count = COUNT(*) FROM Groups WHERE Department = @f AND Speciality = @p;
        END
        ELSE
        BEGIN
            SELECT g.Department, g.Speciality, 
                   COUNT(g.GroupID) AS GroupCount,
                   SUM(g.StudentCount) AS TotalStudents
            FROM Groups g
            GROUP BY g.Department, g.Speciality
            ORDER BY g.Department, g.Speciality;
            
            SELECT @count = COUNT(*) FROM Groups;
        END
        
        RETURN @count;
    END TRY
    BEGIN CATCH
        PRINT 'Error:';
        PRINT 'Number: ' + CAST(ERROR_NUMBER() AS VARCHAR(10));
        PRINT 'Message: ' + ERROR_MESSAGE();
        PRINT 'Security Level: ' + CAST(ERROR_SEVERITY() AS VARCHAR(10));
        PRINT 'State: ' + CAST(ERROR_STATE() AS VARCHAR(10));
        PRINT 'Line: ' + CAST(ERROR_LINE() AS VARCHAR(10));
        IF ERROR_PROCEDURE() IS NOT NULL
            PRINT 'Procedure: ' + ERROR_PROCEDURE();
        
        RETURN -1;
    END CATCH
END;
GO
-- Отчёт
DECLARE @rc INT;
EXEC @rc = PRINT_REPORT;
PRINT 'Groups count: ' + CAST(@rc AS VARCHAR(10));

EXEC @rc = PRINT_REPORT @f = 'Science Department';
PRINT 'Groups count: ' + CAST(@rc AS VARCHAR(10));

EXEC @rc = PRINT_REPORT @p = 'Computer Science';
PRINT 'Groups count: ' + CAST(@rc AS VARCHAR(10));

EXEC @rc = PRINT_REPORT @f = 'Science Department', @p = 'Physics';
PRINT 'Groups count: ' + CAST(@rc AS VARCHAR(10));

BEGIN TRY
    EXEC @rc = PRINT_REPORT @p = 'NonExistingSpeciality';
    PRINT 'Groups count: ' + CAST(@rc AS VARCHAR(10));
END TRY
BEGIN CATCH
    PRINT 'Error catch: ' + ERROR_MESSAGE();
END CATCH