-- 1. INNER JOIN 
SELECT G.GroupNumber, C.CourseName, T.LastName
FROM GroupCourses GC
INNER JOIN Groups G ON GC.GroupID = G.GroupID
INNER JOIN Courses C ON GC.CourseID = C.CourseID
INNER JOIN Teachers T ON GC.TeacherID = T.TeacherID;

-- 2. CASE 
SELECT CourseName, Hours,
    CASE 
        WHEN Hours > 100 THEN 'Долгий курс'
        WHEN Hours BETWEEN 50 AND 100 THEN 'Средний курс'
        ELSE 'Короткий курс'
    END AS DurationCategory
FROM Courses;

-- 3. LEFT JOIN 
SELECT G.GroupNumber, C.CourseName
FROM Groups G
LEFT JOIN GroupCourses GC ON G.GroupID = GC.GroupID
LEFT JOIN Courses C ON GC.CourseID = C.CourseID;

-- 4. FULL OUTER JOIN 
SELECT G.GroupNumber, C.CourseName
FROM Groups G FULL OUTER JOIN GroupCourses GC 
ON G.GroupID = GC.GroupID
FULL OUTER JOIN Courses C ON GC.CourseID = C.CourseID;

-- 5. CROSS JOIN 
SELECT G.GroupNumber, C.CourseName
FROM Groups G
CROSS JOIN Courses C;

--6 TIMETABLE
-- Запрос для поиска свободных аудиторий в понедельник на 1 пару
SELECT 'A101' AS Auditorium
WHERE NOT EXISTS (
    SELECT 1 FROM TIMETABLE 
    WHERE DayOfWeek = 'Monday' 
    AND LessonNumber = 1 
    AND Auditorium = 'A101'
)
UNION ALL
SELECT 'B202' AS Auditorium
WHERE NOT EXISTS (
    SELECT 1 FROM TIMETABLE 
    WHERE DayOfWeek = 'Monday' 
    AND LessonNumber = 1 
    AND Auditorium = 'B202'
)
UNION ALL
SELECT 'C303' AS Auditorium
WHERE NOT EXISTS (
    SELECT 1 FROM TIMETABLE 
    WHERE DayOfWeek = 'Monday' 
    AND LessonNumber = 1 
    AND Auditorium = 'C303'
)
UNION ALL
SELECT 'D404' AS Auditorium
WHERE NOT EXISTS (
    SELECT 1 FROM TIMETABLE 
    WHERE DayOfWeek = 'Monday' 
    AND LessonNumber = 1 
    AND Auditorium = 'D404'
)
UNION ALL
SELECT 'E505' AS Auditorium
WHERE NOT EXISTS (
    SELECT 1 FROM TIMETABLE 
    WHERE DayOfWeek = 'Monday' 
    AND LessonNumber = 1 
    AND Auditorium = 'E505'
);

SELECT G.GroupNumber, G.Speciality, G.Department
FROM Groups G
LEFT JOIN GroupCourses GC ON G.GroupID = GC.GroupID
WHERE GC.GroupID IS NULL;




SELECT G.GroupNumber, C.CourseName, T.LastName AS Teacher
FROM Groups G
FULL OUTER JOIN GroupCourses GC ON G.GroupID = GC.GroupID
FULL OUTER JOIN Courses C ON GC.CourseID = C.CourseID
FULL OUTER JOIN Teachers T ON GC.TeacherID = T.TeacherID
WHERE G.GroupID IS NOT NULL AND C.CourseID IS NOT NULL;

GO

SELECT 
    G.GroupNumber AS GroupNumber,
    C.CourseName AS CourseName,
    'N/A' AS LastName  
FROM 
    Groups G
CROSS JOIN 
    Courses C;