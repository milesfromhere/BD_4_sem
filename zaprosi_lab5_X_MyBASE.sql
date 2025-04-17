--1 Where IN подзапрос
SELECT *
FROM Groups
WHERE GroupID IN (SELECT GroupID FROM GroupCourses WHERE CourseID IN 
                 (SELECT CourseID FROM Courses WHERE Payment > 5000));

--2 !!! Аналогичный подзапрос с iner join
SELECT g.*
FROM Groups g
INNER JOIN (
	SELECT DISTINCT gc.GroupID
	FROM GroupCourses gc
	INNER JOIN (
		SELECT CourseID
		FROM Courses
		WHERE Payment > 5000
	) c ON gc.CourseID = c.CourseID
) answer ON g.GroupID=answer.GroupID



--3 Первый запрос без подзадачи через inner join
SELECT DISTINCT g.*
FROM Groups g
INNER JOIN GroupCourses gc ON g.GroupID = gc.GroupID
INNER JOIN Courses c ON gc.CourseID = c.CourseID
WHERE c.Payment > 5000;

--4 !!! MAX опыт
SELECT t.*
FROM Teachers t
WHERE t.Experience = (SELECT MAX(Experience) FROM Teachers);

SELECT TOP 1 t.*
FROM Teachers t
ORDER BY t.Experience DESC

SELECT t.*
FROM Teachers t
WHERE NOT EXISTS (
	SELECT 1
	FROM Teachers t2
	WHERE t2.Experience>t.Experience
	);

--5 !!! EXISTS
SELECT *
FROM Courses c
WHERE EXISTS (
	SELECT 1 
	FROM GroupCourses gc
	WHERE gc.CourseID = c.CourseID
	)

--6 AVG
SELECT AVG(Payment) AS AvgPayment
FROM Courses 
WHERE CourseID IN (
	SELECT CourseID
	FROM GroupCourses
	WHERE GroupID IN (
		SELECT GroupID
		FROM Groups
WHERE GroupNumber = 'G101')
);


--!!!
SELECT TOP (1) (SELECT AVG(Payment) FROM Courses) FROM Courses;

--7 select ALL
SELECT *
FROM Teachers
WHERE Experience > ALL (SELECT Experience FROM Teachers WHERE LastName = 'Smith');

--8 select ANY
SELECT *
FROM Courses
WHERE Payment > ANY (SELECT Payment FROM Courses WHERE Subject = 'Mathematics');

SELECT DISTINCT g.*
FROM Groups g
JOIN TIMETABLE t ON g.GroupID = t.GroupID
WHERE t.Auditorium = 'A101';


SELECT *
FROM Teachers
WHERE TeacherID NOT IN (
    SELECT DISTINCT TeacherID 
    FROM TIMETABLE 
    WHERE DayOfWeek = 'Monday'
);
