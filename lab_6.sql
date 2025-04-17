-- 1 Определить количество студентов и специальности для каждого факультета
SELECT 
    Department AS Факультет,
    Speciality AS Специальность,
    SUM(StudentCount) AS [Количество студентов]
FROM 
    Groups
GROUP BY 
    Department, Speciality
ORDER BY 
    Department, Speciality;

--2 Определить пределы изменения оплаты за курсы и количество курсов каждого типа
SELECT 
    LessonType AS [Тип занятия],
    MIN(Payment) AS [Минимальная оплата],
    MAX(Payment) AS [Максимальная оплата],
    AVG(Payment) AS [Средняя оплата],
    COUNT(*) AS [Количество курсов]
FROM 
    Courses
GROUP BY 
    LessonType;
-- 3 
SELECT 
    t.DayOfWeek AS [День недели],
    COUNT(*) AS [Количество занятий],
    AVG(c.Hours) AS [Среднее количество часов]
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

-- 4 Определить названия курсов, факультеты групп, которые их изучают, и среднее количество часов

SELECT 
    c.CourseName AS [Название курса],
    g.Department AS [Факультет],
    c.Hours AS [Количество часов],
    ROUND(AVG(c.Hours), 2) AS [Среднее количество часов]
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

-- 5 Переписать запрос 4 с использованием CAST и ROUND
SELECT 
    c.CourseName AS [Название курса],
    g.Department AS [Факультет],
    CAST(c.Hours AS DECIMAL(10,2)) AS [Количество часов],
    ROUND(AVG(c.Hours), 2) AS [Среднее количество часов]
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

-- 6 Определить количество занятий и аудитории для лекций и семинаров
SELECT 
    c.LessonType AS [Тип занятия],
    COUNT(*) AS [Количество занятий],
    STRING_AGG(t.Auditorium, ', ') AS [Аудитории]
FROM 
    TIMETABLE t
INNER JOIN 
    Courses c ON t.CourseID = c.CourseID
WHERE 
    c.LessonType IN ('Lecture', 'Seminar')
GROUP BY 
    c.LessonType;
-- 7 Найти преподавателей с опытом работы меньше 5 или больше 10 лет и количество курсов, которые они ведут

SELECT 
    t.LastName AS [Фамилия],
    t.FirstName AS [Имя],
    t.Experience AS [Опыт работы],
    COUNT(gc.CourseID) AS [Количество курсов]
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

-- 8 Определить дни недели с наибольшим количеством занятий (используем HAVING)
SELECT 
    DayOfWeek AS [День недели],
    COUNT(*) AS [Количество занятий]
FROM 
    TIMETABLE
GROUP BY 
    DayOfWeek
HAVING 
    COUNT(*) > 1
ORDER BY 
    COUNT(*) DESC;