--���14

--1. ��������� ������� ��� �������� ���������� ��������� �� ����������
CREATE FUNCTION dbo.COUNT_STUDENTS(@faculty NVARCHAR(100), @default INT = NULL)
RETURNS INT
AS
BEGIN
    DECLARE @count INT;
    
    IF @faculty IS NULL
        SELECT @count = SUM(StudentCount) FROM Groups;
    ELSE
        SELECT @count = SUM(StudentCount) 
        FROM Groups 
        WHERE Department = @faculty;
    
    RETURN ISNULL(@count, 0);
END;


--2. ��������� ������� ��� ������������ ������ ������ ������
CREATE FUNCTION dbo.FCOURSES(@groupID INT)
RETURNS NVARCHAR(500)
AS
BEGIN
    DECLARE @result NVARCHAR(500) = 'Group Courses: ';
    DECLARE @courseName NVARCHAR(100);
    
    DECLARE course_cursor CURSOR FOR
    SELECT c.CourseName 
    FROM GroupCourses gc
    JOIN Courses c ON gc.CourseID = c.CourseID
    WHERE gc.GroupID = @groupID;
    
    OPEN course_cursor;
    FETCH NEXT FROM course_cursor INTO @courseName;
    
    WHILE @@FETCH_STATUS = 0
    BEGIN
        SET @result = @result + @courseName + ', ';
        FETCH NEXT FROM course_cursor INTO @courseName;
    END;
    
    CLOSE course_cursor;
    DEALLOCATE course_cursor;
    
    -- ������� ��������� ������� � ������
    IF LEN(@result) > 13
        SET @result = LEFT(@result, LEN(@result) - 2);
    
    RETURN @result;
END;

--3. ���������� ��������� ������� ��� ��������� ���������� ������
CREATE FUNCTION dbo.FGROUP_SCHEDULE(@groupID INT)
RETURNS TABLE
AS
RETURN
(
    SELECT 
        t.DayOfWeek AS 'Day of Week0',
        t.LessonNumber AS 'Lesson Number',
        c.CourseName AS 'Course',
        te.LastName + ' ' + LEFT(te.FirstName, 1) + '.' AS 'Lector',
        t.Auditorium AS 'Auditorium'
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
        t.LessonNumber
);

--4. ���������������� ��������� ������� ��� ������ �� ����������

CREATE FUNCTION dbo.FACULTY_REPORT(@minStudents INT)
RETURNS @report TABLE
(
    ��������� NVARCHAR(100),
    [���������� ������] INT,
    [���������� �����] INT,
    [���������� ���������] INT,
    [���������� ��������������] INT
)
AS
BEGIN
    DECLARE @faculty NVARCHAR(100);
    
    DECLARE faculty_cursor CURSOR FOR
    SELECT DISTINCT Department FROM Groups
    WHERE dbo.COUNT_STUDENTS(Department, DEFAULT) > @minStudents;
    
    OPEN faculty_cursor;
    FETCH NEXT FROM faculty_cursor INTO @faculty;
    
    WHILE @@FETCH_STATUS = 0
    BEGIN
        INSERT INTO @report
        SELECT 
            @faculty,
            (SELECT COUNT(DISTINCT Speciality) FROM Groups WHERE Department = @faculty),
            (SELECT COUNT(*) FROM Groups WHERE Department = @faculty),
            dbo.COUNT_STUDENTS(@faculty, DEFAULT),
            (SELECT COUNT(DISTINCT Speciality) FROM Groups WHERE Department = @faculty);
            
        FETCH NEXT FROM faculty_cursor INTO @faculty;
    END;
    
    CLOSE faculty_cursor;
    DEALLOCATE faculty_cursor;
    
    RETURN;
END;

--1. ������������� ��������� ������� COUNT_STUDENTS
SELECT dbo.COUNT_STUDENTS(NULL, DEFAULT) AS 'Students count';

SELECT dbo.COUNT_STUDENTS('Science Department', DEFAULT) AS 'Science Department Students';

--2. ������������� ������� FCOURSES

SELECT dbo.FCOURSES(1) AS 'Group courses';

SELECT 
    g.GroupNumber AS 'Group',
    dbo.FCOURSES(g.GroupID) AS 'Course'
FROM Groups g;


--3. ������������� ��������� ������� FGROUP_SCHEDULE
SELECT * FROM dbo.FGROUP_SCHEDULE(1);

DECLARE @groupID INT;
DECLARE group_cursor CURSOR FOR SELECT GroupID FROM Groups;

OPEN group_cursor;
FETCH NEXT FROM group_cursor INTO @groupID;

WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT 'Raspisanie for group ID: ' + CAST(@groupID AS NVARCHAR(10));
    SELECT * FROM dbo.FGROUP_SCHEDULE(@groupID);
    FETCH NEXT FROM group_cursor INTO @groupID;
END;

CLOSE group_cursor;
DEALLOCATE group_cursor;

--4. ������������� ������� FACULTY_REPORT
SELECT * FROM dbo.FACULTY_REPORT(25);

SELECT * FROM dbo.FACULTY_REPORT(50);

--1. �������� ��������������� ��������� �������

CREATE FUNCTION dbo.COUNT_DEPARTMENTS(@faculty NVARCHAR(100))
RETURNS INT
AS
BEGIN
    DECLARE @count INT;
    
    SELECT @count = COUNT(DISTINCT Speciality)
    FROM Groups
    WHERE Department = @faculty;
    
    RETURN ISNULL(@count, 0);
END;

CREATE FUNCTION dbo.COUNT_GROUPS(@faculty NVARCHAR(100))
RETURNS INT
AS
BEGIN
    DECLARE @count INT;
    
    SELECT @count = COUNT(*)
    FROM Groups
    WHERE Department = @faculty;
    
    RETURN ISNULL(@count, 0);
END;

CREATE FUNCTION dbo.COUNT_SPECIALITIES(@faculty NVARCHAR(100))
RETURNS INT
AS
BEGIN
    DECLARE @count INT;
    
    SELECT @count = COUNT(DISTINCT Speciality)
    FROM Groups
    WHERE Department = @faculty;
    
    RETURN ISNULL(@count, 0);
END;

--2. ���������������� ������� FACULTY_REPORT
ALTER FUNCTION dbo.FACULTY_REPORT(@minStudents INT)
RETURNS @report TABLE
(
    ��������� NVARCHAR(100),
    [���������� ������] INT,
    [���������� �����] INT,
    [���������� ���������] INT,
    [���������� ��������������] INT
)
AS
BEGIN
    DECLARE @faculty NVARCHAR(100);
    
    DECLARE faculty_cursor CURSOR FOR
    SELECT DISTINCT Department FROM Groups
    WHERE dbo.COUNT_STUDENTS(Department, DEFAULT) > @minStudents;
    
    OPEN faculty_cursor;
    FETCH NEXT FROM faculty_cursor INTO @faculty;
    
    WHILE @@FETCH_STATUS = 0
    BEGIN
        INSERT INTO @report
        SELECT 
            @faculty,
            dbo.COUNT_DEPARTMENTS(@faculty),
            dbo.COUNT_GROUPS(@faculty),
            dbo.COUNT_STUDENTS(@faculty, DEFAULT),
            dbo.COUNT_SPECIALITIES(@faculty);
            
        FETCH NEXT FROM faculty_cursor INTO @faculty;
    END;
    
    CLOSE faculty_cursor;
    DEALLOCATE faculty_cursor;
    
    RETURN;
END;


--1. �������� ��������������� �������

-- ������� ��� ��������� ������ ���������
CREATE FUNCTION dbo.FSUBJECTS(@teacherID INT)
RETURNS NVARCHAR(500)
AS
BEGIN
    DECLARE @result NVARCHAR(500) = '';
    DECLARE @subject NVARCHAR(100);
    
    DECLARE subject_cursor CURSOR FOR
    SELECT DISTINCT c.Subject
    FROM GroupCourses gc
    JOIN Courses c ON gc.CourseID = c.CourseID
    WHERE gc.TeacherID = @teacherID;
    
    OPEN subject_cursor;
    FETCH NEXT FROM subject_cursor INTO @subject;
    
    WHILE @@FETCH_STATUS = 0
    BEGIN
        SET @result = @result + @subject + ', ';
        FETCH NEXT FROM subject_cursor INTO @subject;
    END;
    
    CLOSE subject_cursor;
    DEALLOCATE subject_cursor;
    
    IF LEN(@result) > 0
        SET @result = LEFT(@result, LEN(@result) - 2);
    
    RETURN @result;
END;

-- ������� ��� ��������� ���������� � ������� �������������
CREATE FUNCTION dbo.FFACPUL(@teacherID INT)
RETURNS NVARCHAR(200)
AS
BEGIN
    DECLARE @result NVARCHAR(200) = '';
    
    SELECT @result = g.Department + ' (' + g.Speciality + ')'
    FROM GroupCourses gc
    JOIN Groups g ON gc.GroupID = g.GroupID
    WHERE gc.TeacherID = @teacherID
    GROUP BY g.Department, g.Speciality;
    
    RETURN ISNULL(@result, '�� ��������');
END;

-- ������� ��� ��������� ��� �������������
CREATE FUNCTION dbo.FCTEACHER(@teacherID INT)
RETURNS NVARCHAR(150)
AS
BEGIN
    DECLARE @result NVARCHAR(150);
    
    SELECT @result = LastName + ' ' + LEFT(FirstName, 1) + '.' + ISNULL(' ' + LEFT(MiddleName, 1) + '.', '')
    FROM Teachers
    WHERE TeacherID = @teacherID;
    
    RETURN ISNULL(@result, 'Not found');
END;

--2. �������� ��������� PRINT_REPORTX
CREATE PROCEDURE dbo.PRINT_REPORTX
    @minExperience INT = 0,
    @maxExperience INT = 100,
    @lessonType NVARCHAR(50) = NULL
AS
BEGIN
    DECLARE @teacherID INT;
    DECLARE @experience INT;
    DECLARE @subjects NVARCHAR(500);
    DECLARE @facpul NVARCHAR(200);
    DECLARE @teacherName NVARCHAR(150);
    
    PRINT 'Otcet';
    PRINT 'Expirience ' + CAST(@minExperience AS NVARCHAR) + ' �� ' + CAST(@maxExperience AS NVARCHAR) + ' ���';
    IF @lessonType IS NOT NULL
        PRINT 'Lesson Type: ' + @lessonType;
    PRINT '------------------------------------------------------------';
    
    DECLARE teacher_cursor CURSOR FOR
    SELECT DISTINCT t.TeacherID, t.Experience
    FROM Teachers t
    JOIN GroupCourses gc ON t.TeacherID = gc.TeacherID
    JOIN Courses c ON gc.CourseID = c.CourseID
    WHERE t.Experience BETWEEN @minExperience AND @maxExperience
    AND (@lessonType IS NULL OR c.LessonType = @lessonType)
    ORDER BY t.Experience DESC;
    
    OPEN teacher_cursor;
    FETCH NEXT FROM teacher_cursor INTO @teacherID, @experience;
    
    WHILE @@FETCH_STATUS = 0
    BEGIN
        SET @subjects = dbo.FSUBJECTS(@teacherID);
        SET @facpul = dbo.FFACPUL(@teacherID);
        SET @teacherName = dbo.FCTEACHER(@teacherID);
        
        PRINT 'Teacher: ' + @teacherName;
        PRINT 'Expirience: ' + CAST(@experience AS NVARCHAR) + ' years';
        PRINT 'Faculty/pullpit: ' + @facpul;
        PRINT 'Teacher subject: ' + @subjects;
        PRINT '------------------------------------------------------------';
        
        FETCH NEXT FROM teacher_cursor INTO @teacherID, @experience;
    END;
    
    CLOSE teacher_cursor;
    DEALLOCATE teacher_cursor;
END;

--3. ��������� ������ PRINT_REPORT � PRINT_REPORTX

CREATE PROCEDURE dbo.PRINT_REPORT
    @minExperience INT = 0,
    @maxExperience INT = 100,
    @lessonType NVARCHAR(50) = NULL
AS
BEGIN
    DECLARE @teacherID INT;
    DECLARE @lastName NVARCHAR(50);
    DECLARE @firstName NVARCHAR(50);
    DECLARE @middleName NVARCHAR(50);
    DECLARE @experience INT;
    DECLARE @subjects NVARCHAR(500);
    DECLARE @faculty NVARCHAR(100);
    DECLARE @pulpit NVARCHAR(100);
    
    PRINT 'Otchet';
    PRINT 'Expirience ' + CAST(@minExperience AS NVARCHAR) + ' ot' + CAST(@maxExperience AS NVARCHAR) + ' years';
    IF @lessonType IS NOT NULL
        PRINT 'Lesson Type: ' + @lessonType;
    PRINT '------------------------------------------------------------';
    
    DECLARE teacher_cursor CURSOR FOR
    SELECT DISTINCT t.TeacherID, t.LastName, t.FirstName, t.MiddleName, t.Experience
    FROM Teachers t
    JOIN GroupCourses gc ON t.TeacherID = gc.TeacherID
    JOIN Courses c ON gc.CourseID = c.CourseID
    JOIN Groups g ON gc.GroupID = g.GroupID
    WHERE t.Experience BETWEEN @minExperience AND @maxExperience
    AND (@lessonType IS NULL OR c.LessonType = @lessonType)
    ORDER BY t.Experience DESC;
    
    OPEN teacher_cursor;
    FETCH NEXT FROM teacher_cursor INTO @teacherID, @lastName, @firstName, @middleName, @experience;
    
    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- �������� ������ ���������
        SET @subjects = '';
        SELECT @subjects = @subjects + c.Subject + ', '
        FROM GroupCourses gc
        JOIN Courses c ON gc.CourseID = c.CourseID
        WHERE gc.TeacherID = @teacherID
        GROUP BY c.Subject;
        
        IF LEN(@subjects) > 0
            SET @subjects = LEFT(@subjects, LEN(@subjects) - 2);
        
        SELECT TOP 1 @faculty = g.Department, @pulpit = g.Speciality
        FROM GroupCourses gc
        JOIN Groups g ON gc.GroupID = g.GroupID
        WHERE gc.TeacherID = @teacherID;
        
        PRINT 'Teacher: ' + @lastName + ' ' + LEFT(@firstName, 1) + '.' + ISNULL(' ' + LEFT(@middleName, 1) + '.', '');
        PRINT 'Expirience: ' + CAST(@experience AS NVARCHAR) + ' years';
        PRINT 'Faculty/pullpit: ' + ISNULL(@faculty, '') + ' (' + ISNULL(@pulpit, '') + ')';
        PRINT 'Teacher subject: ' + ISNULL(@subjects, '');
        PRINT '------------------------------------------------------------';
        
        FETCH NEXT FROM teacher_cursor INTO @teacherID, @lastName, @firstName, @middleName, @experience;
    END;
    
    CLOSE teacher_cursor;
    DEALLOCATE teacher_cursor;
END;

EXEC dbo.PRINT_REPORT @minExperience = 5, @maxExperience = 10;

EXEC dbo.PRINT_REPORTX @minExperience = 5, @maxExperience = 10;

EXEC dbo.PRINT_REPORT @lessonType = 'Lecture';
EXEC dbo.PRINT_REPORTX @lessonType = 'Lecture';