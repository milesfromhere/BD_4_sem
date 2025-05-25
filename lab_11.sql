USE X_NyBASE;
GO

-- 1. ������ ������� ��� ������ ������ ����� � �� �������������� ����� �������
DECLARE @GroupList NVARCHAR(MAX) = '';
DECLARE @GroupNumber1 NVARCHAR(50), @Speciality NVARCHAR(100);

DECLARE GroupCursor CURSOR LOCAL STATIC 
FOR SELECT GroupNumber, Speciality FROM Groups;

OPEN GroupCursor;
FETCH NEXT FROM GroupCursor INTO @GroupNumber1, @Speciality;

WHILE @@FETCH_STATUS = 0
BEGIN
    SET @GroupList = @GroupList + @GroupNumber1 + ' (' + @Speciality + '), ';
    FETCH NEXT FROM GroupCursor INTO @GroupNumber1, @Speciality;
END

CLOSE GroupCursor;
DEALLOCATE GroupCursor;

-- ������� ��������� �������
IF LEN(@GroupList) > 0
    SET @GroupList = LEFT(@GroupList, LEN(@GroupList) - 1);

PRINT 'Groups and Specification: ' + @GroupList;
GO

-- 2. ������ ���������� � ����������� ������� (��� � ������� 2)
-- ��������� ������
DECLARE TeachersLocal CURSOR LOCAL
FOR SELECT LastName, FirstName, Experience FROM Teachers;

DECLARE @LastName NVARCHAR(50), @FirstName NVARCHAR(50), @Exp INT;

OPEN TeachersLocal;
FETCH TeachersLocal INTO @LastName, @FirstName, @Exp;
PRINT '1. ' + @LastName + ' ' + @FirstName + ', YEARs: ' + CAST(@Exp AS NVARCHAR);
GO

-- ������� ������������ ��������� ������ � ����� ������ ������� ������
DECLARE @LastName NVARCHAR(50), @FirstName NVARCHAR(50), @Exp INT;
FETCH TeachersLocal INTO @LastName, @FirstName, @Exp; -- ������: ������ �� ����������
GO

-- ���������� ������
DECLARE TeachersGlobal CURSOR GLOBAL
FOR SELECT LastName, FirstName, Experience FROM Teachers;

OPEN TeachersGlobal;
GO

-- ������������� ����������� ������� � ������ ������
DECLARE @LastName NVARCHAR(50), @FirstName NVARCHAR(50), @Exp INT;
FETCH TeachersGlobal INTO @LastName, @FirstName, @Exp;
PRINT '2. ' + @LastName + ' ' + @FirstName + ', YEARs: ' + CAST(@Exp AS NVARCHAR);

CLOSE TeachersGlobal;
DEALLOCATE TeachersGlobal;
GO

-- 3. ������ ������������ � ������������� ������� (��� � ������� 3)
-- ����������� ������
DECLARE @CourseName NVARCHAR(100), @Hours INT;

DECLARE StaticCursor CURSOR LOCAL STATIC
FOR SELECT CourseName, Hours FROM Courses;

OPEN StaticCursor;
PRINT 'STROK VSEGO: ' + CAST(@@CURSOR_ROWS AS NVARCHAR);

-- ������ ��������� � ������
UPDATE Courses SET Hours = 200 WHERE CourseID = 1;
DELETE FROM Courses WHERE CourseID = 2;
INSERT INTO Courses (CourseName, Hours, Subject, LessonType, Payment)
VALUES ('New Course', 50, 'Test', 'Lecture', 3000.00);

FETCH NEXT FROM StaticCursor INTO @CourseName, @Hours;
WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT @CourseName + ' - ' + CAST(@Hours AS NVARCHAR) + ' HOURS';
    FETCH NEXT FROM StaticCursor INTO @CourseName, @Hours;
END

CLOSE StaticCursor;
DEALLOCATE StaticCursor;
GO

-- ������������ ������ (������� ���������)
DECLARE DynamicCursor CURSOR LOCAL DYNAMIC
FOR SELECT CourseName, Hours FROM Courses;

OPEN DynamicCursor;
FETCH NEXT FROM DynamicCursor INTO @CourseName, @Hours;
WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT @CourseName + ' - ' + CAST(@Hours AS NVARCHAR) + ' HOURS (DYNAMIC)';
    FETCH NEXT FROM DynamicCursor INTO @CourseName, @Hours;
END

CLOSE DynamicCursor;
DEALLOCATE DynamicCursor;
GO

-- ����������� ��������� ������ ��� ��������� ��������
INSERT INTO Courses (CourseName, Hours, Subject, LessonType, Payment)
VALUES ('Advanced Mathematics', 90, 'Mathematics', 'Seminar', 4500.00);
UPDATE Courses SET Hours = 120 WHERE CourseName = 'Python Programming';
GO

-- 4. ������ ������� � SCROLL (��� � ������� 4)
DECLARE @RowNum INT, @CourseInfo NVARCHAR(150);

DECLARE ScrollCursor CURSOR LOCAL DYNAMIC SCROLL
FOR SELECT 
    ROW_NUMBER() OVER (ORDER BY CourseName) AS RowNum,
    CourseName + ' (' + Subject + ')' AS CourseInfo
FROM Courses;

OPEN ScrollCursor;

-- ������ ������
FETCH FIRST FROM ScrollCursor INTO @RowNum, @CourseInfo;
PRINT 'First string: ' + CAST(@RowNum AS NVARCHAR) + '. ' + @CourseInfo;

-- ��������� ������
FETCH LAST FROM ScrollCursor INTO @RowNum, @CourseInfo;
PRINT 'Last string: ' + CAST(@RowNum AS NVARCHAR) + '. ' + @CourseInfo;

-- ��������� ������
FETCH NEXT FROM ScrollCursor INTO @RowNum, @CourseInfo;
PRINT 'Next after last: ' + CAST(@RowNum AS NVARCHAR) + '. ' + @CourseInfo;

-- ���������� ������
FETCH PRIOR FROM ScrollCursor INTO @RowNum, @CourseInfo;
PRINT 'Before: ' + CAST(@RowNum AS NVARCHAR) + '. ' + @CourseInfo;

-- ���������� ������� 2
FETCH ABSOLUTE 2 FROM ScrollCursor INTO @RowNum, @CourseInfo;
PRINT 'Absolut 2: ' + CAST(@RowNum AS NVARCHAR) + '. ' + @CourseInfo;

-- ������������� ������� +1
FETCH RELATIVE 1 FROM ScrollCursor INTO @RowNum, @CourseInfo;
PRINT 'Otnositel +1: ' + CAST(@RowNum AS NVARCHAR) + '. ' + @CourseInfo;

CLOSE ScrollCursor;
DEALLOCATE ScrollCursor;
GO

-- 5. ������ ������� FOR UPDATE (��� � ������� 5)
DECLARE UpdateCursor CURSOR LOCAL DYNAMIC
FOR SELECT CourseID, CourseName, Hours FROM Courses
FOR UPDATE;

OPEN UpdateCursor;
FETCH NEXT FROM UpdateCursor INTO @CourseID, @CourseName, @Hours;

WHILE @@FETCH_STATUS = 0
BEGIN
    -- ����������� ���������� ����� �� 10 ��� ������� �����
    UPDATE Courses SET Hours = Hours + 10 
    WHERE CURRENT OF UpdateCursor;
    
    PRINT 'Update course: ' + @CourseName + ', new Hours: ' + CAST((@Hours + 10) AS NVARCHAR);
    
    FETCH NEXT FROM UpdateCursor INTO @CourseID, @CourseName, @Hours;
END

CLOSE UpdateCursor;
DEALLOCATE UpdateCursor;
GO

-- 6. ������ SELECT-������� � �������� ��� ��������� ������ (��� � ������� 6)
DECLARE @GroupNumber NVARCHAR(50), @CourseCount INT, @CoursesList NVARCHAR(MAX);

DECLARE GroupCourseCursor CURSOR LOCAL STATIC
FOR 
SELECT 
    g.GroupNumber,
    COUNT(gc.CourseID) AS CourseCount,
    STRING_AGG(c.CourseName, ', ') WITHIN GROUP (ORDER BY c.CourseName) AS CoursesList
FROM Groups g
LEFT JOIN GroupCourses gc ON g.GroupID = gc.GroupID
LEFT JOIN Courses c ON gc.CourseID = c.CourseID
GROUP BY g.GroupNumber;

OPEN GroupCourseCursor;
FETCH NEXT FROM GroupCourseCursor INTO @GroupNumber, @CourseCount, @CoursesList;

WHILE @@FETCH_STATUS = 0
BEGIN
    IF @CourseCount = 0
        PRINT 'Group ' + @GroupNumber + ': no courses';
    ELSE
        PRINT 'Group ' + @GroupNumber + ': ' + @CoursesList + '.';
    
    FETCH NEXT FROM GroupCourseCursor INTO @GroupNumber, @CourseCount, @CoursesList;
END

CLOSE GroupCourseCursor;
DEALLOCATE GroupCourseCursor;
GO

-- 8*. ������������ ������ �� �����������, ��������, �������������� � �����������
DECLARE @FacultyName NVARCHAR(100), @PulpitName NVARCHAR(100), 
        @TeacherCount INT, @SubjectsList NVARCHAR(MAX);

-- ������� ��������� ������� ��� �������� �����������
CREATE TABLE #FacultyReport (
    FacultyName NVARCHAR(100),
    PulpitName NVARCHAR(100),
    TeacherCount INT,
    SubjectsList NVARCHAR(MAX)
);

-- ������ ��� ��������� ������
DECLARE ReportCursor CURSOR LOCAL STATIC
FOR 
SELECT 
    g.Department AS FacultyName,
    g.Speciality AS PulpitName,
    COUNT(DISTINCT gc.TeacherID) AS TeacherCount,
    CASE 
        WHEN COUNT(DISTINCT c.CourseID) = 0 THEN '���'
        ELSE (
            SELECT STRING_AGG(c.CourseName, ', ') WITHIN GROUP (ORDER BY c.CourseName) + '.'
        END AS SubjectsList
FROM Groups g
LEFT JOIN GroupCourses gc ON g.GroupID = gc.GroupID
LEFT JOIN Courses c ON gc.CourseID = c.CourseID
GROUP BY g.Department, g.Speciality;

OPEN ReportCursor;
FETCH NEXT FROM ReportCursor INTO @FacultyName, @PulpitName, @TeacherCount, @SubjectsList;

WHILE @@FETCH_STATUS = 0
BEGIN
    INSERT INTO #FacultyReport (FacultyName, PulpitName, TeacherCount, SubjectsList)
    VALUES (@FacultyName, @PulpitName, @TeacherCount, @SubjectsList);
    
    FETCH NEXT FROM ReportCursor INTO @FacultyName, @PulpitName, @TeacherCount, @SubjectsList;
END

CLOSE ReportCursor;
DEALLOCATE ReportCursor;

-- ������� �����
SELECT 
    FacultyName AS '���������',
    PulpitName AS '�������',
    TeacherCount AS '���-�� ��������������',
    SubjectsList AS '����������'
FROM #FacultyReport
ORDER BY FacultyName, PulpitName;

DROP TABLE #FacultyReport;
GO