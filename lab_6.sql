-- 1 ���������� ���������� ��������� � ������������� ��� ������� ����������
SELECT 
    Department AS ���������,
    Speciality AS �������������,
    SUM(StudentCount) AS [���������� ���������]
FROM 
    Groups
GROUP BY 
    Department, Speciality
ORDER BY 
    Department, Speciality;

--2 ���������� ������� ��������� ������ �� ����� � ���������� ������ ������� ����
SELECT 
    LessonType AS [��� �������],
    MIN(Payment) AS [����������� ������],
    MAX(Payment) AS [������������ ������],
    AVG(Payment) AS [������� ������],
    COUNT(*) AS [���������� ������]
FROM 
    Courses
GROUP BY 
    LessonType;
-- 3 
SELECT 
    t.DayOfWeek AS [���� ������],
    COUNT(*) AS [���������� �������],
    AVG(c.Hours) AS [������� ���������� �����]
FROM 
    TIMETABLE t
INNER JOIN 
    Courses c ON t.CourseID = c.CourseID
GROUP BY 
    t.DayOfWeek
ORDER BY 
    CASE t.DayOfWeek
        WHEN 'Monday' THEN 1
        WHEN 'Tuesday' THEN 2
        WHEN 'Wednesday' THEN 3
        WHEN 'Thursday' THEN 4
        WHEN 'Friday' THEN 5
        WHEN 'Saturday' THEN 6
        WHEN 'Sunday' THEN 7
    END;

-- 4 ���������� �������� ������, ���������� �����, ������� �� �������, � ������� ���������� �����

SELECT 
    c.CourseName AS [�������� �����],
    g.Department AS [���������],
    c.Hours AS [���������� �����],
    ROUND(AVG(c.Hours), 2) AS [������� ���������� �����]
FROM 
    GroupCourses gc
INNER JOIN 
    Courses c ON gc.CourseID = c.CourseID
INNER JOIN 
    Groups g ON gc.GroupID = g.GroupID
WHERE 
    c.Hours > 50
GROUP BY 
    c.CourseName, g.Department, c.Hours;

-- 5 ���������� ������ 4 � �������������� CAST � ROUND
SELECT 
    c.CourseName AS [�������� �����],
    g.Department AS [���������],
    CAST(c.Hours AS DECIMAL(10,2)) AS [���������� �����],
    ROUND(AVG(c.Hours), 2) AS [������� ���������� �����]
FROM 
    GroupCourses gc
INNER JOIN 
    Courses c ON gc.CourseID = c.CourseID
INNER JOIN 
    Groups g ON gc.GroupID = g.GroupID
WHERE 
    c.Hours > 50
GROUP BY 
    c.CourseName, g.Department, c.Hours;

-- 6 ���������� ���������� ������� � ��������� ��� ������ � ���������
SELECT 
    c.LessonType AS [��� �������],
    COUNT(*) AS [���������� �������],
    STRING_AGG(t.Auditorium, ', ') AS [���������]
FROM 
    TIMETABLE t
INNER JOIN 
    Courses c ON t.CourseID = c.CourseID
WHERE 
    c.LessonType IN ('Lecture', 'Seminar')
GROUP BY 
    c.LessonType;
-- 7 ����� �������������� � ������ ������ ������ 5 ��� ������ 10 ��� � ���������� ������, ������� ��� �����

SELECT 
    t.LastName AS [�������],
    t.FirstName AS [���],
    t.Experience AS [���� ������],
    COUNT(gc.CourseID) AS [���������� ������]
FROM 
    Teachers t
INNER JOIN 
    GroupCourses gc ON t.TeacherID = gc.TeacherID
GROUP BY 
    t.LastName, t.FirstName, t.Experience
HAVING 
    t.Experience < 5 OR t.Experience > 10
ORDER BY 
    t.LastName;

-- 8 ���������� ��� ������ � ���������� ����������� ������� (���������� HAVING)
SELECT 
    DayOfWeek AS [���� ������],
    COUNT(*) AS [���������� �������]
FROM 
    TIMETABLE
GROUP BY 
    DayOfWeek
HAVING 
    COUNT(*) > 1
ORDER BY 
    COUNT(*) DESC;