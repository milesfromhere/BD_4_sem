--1
--SELECT Speciality [Специальность],Department [Кафедра],StudentCount [Колличество студентов]from Groups

CREATE VIEW [Универ]
AS SELECT Speciality [Специальность],
Department [Кафедра],
StudentCount [Колличество студентов]
from Groups

--DROP VIEW [Универ]

ALTER VIEW [Универ]
AS SELECT 
Department [Кафедра],

Speciality [Специальность],

StudentCount [Колличество студентов]
from Groups
--1.1 
CREATE VIEW [Универ] AS SELECT * FROM Groups;

SELECT * FROM [Универ] ORDER BY [Колличество студентов];

SELECT * FROM [Универ] WHERE [Кафедра] = 'Technical Department';

--2
CREATE VIEW [Количество кафедр] AS
SELECT 
    Faculty AS [Факультет],
    Speciality AS [Специальность],
    Department AS [Кафедра],
    COUNT(*) OVER (PARTITION BY Faculty, Speciality) AS [Количество кафедр]
FROM Groups;

--DROP VIEW [Количество кафедр]

--2.1

ALTER VIEW [Количество кафедр] AS
SELECT 
    GroupNumber AS [Номер группы], 
    Department AS [Кафедра],
    Speciality AS [Специальность],
    Faculty AS [Факультет],
    StudentCount AS [Кол-во студентов] 
FROM Groups;

-- Вставка новой записи
INSERT INTO [Количество кафедр] ([Номер группы],[Кафедра], [Специальность], [Факультет], [Кол-во студентов])
VALUES ('G152','Новая кафедра', 'Новая специальность', 'Факультет', 52);

-- Обновление данных
UPDATE [Количество кафедр]
SET [Факультет] = 'Новый факультет'
WHERE [Кафедра] = 'Новая кафедра';

-- Удаление записи
DELETE FROM [Количество кафедр]
WHERE [Кафедра] = 'Новая кафедра';

--3
CREATE VIEW [Аудитории]
AS SELECT
TimetableID as [Номер пары],
Auditorium as [Аудитория],
LessonNumber as [Номер лекции]
FROM TIMETABLE;

--DROP VIEW [Аудитории]

--3.1

ALTER VIEW [Аудитории] AS
SELECT
    TimetableID as [Номер пары],
    Auditorium as [Аудитория],
    LessonNumber as [Номер лекции],
    TeacherID as [Преподаватель],
    GroupID as [Группа],
    CourseID as [ID курса],
    DayOfWeek as [День недели]
FROM TIMETABLE;

INSERT INTO [Аудитории] ([Аудитория],[Номер лекции],[Преподаватель],[Группа],[ID курса],[День недели])
VALUES ('G101',52, 1, 1, 5, 'Monday');

UPDATE [Аудитории] 
SET 
    [Аудитория] = 'G153',
    [Номер лекции] = 53
WHERE 
    [Номер пары] = 1;

	DELETE FROM [Аудитории] 
WHERE [Номер пары] = 1;

--4
CREATE VIEW [Аудитории]
AS SELECT
TimetableID as [Номер пары],
Auditorium as [Аудитория],
LessonNumber as [Номер лекции]
FROM TIMETABLE where LessonNumber >1 WITH CHECK OPTION;

--DROP VIEW [Аудитории]

--4.1

ALTER VIEW [Аудитории] AS
SELECT
    TimetableID as [Номер пары],
    Auditorium as [Аудитория],
    LessonNumber as [Номер лекции],
    TeacherID as [Преподаватель],
    GroupID as [Группа],
    CourseID as [ID курса],
    DayOfWeek as [День недели]
FROM TIMETABLE where LessonNumber >1 WITH CHECK OPTION;

INSERT INTO [Аудитории] ([Аудитория],[Номер лекции],[Преподаватель],[Группа],[ID курса],[День недели])
VALUES ('G101',52, 10, 1, 5, 'Monday');

UPDATE [Аудитории] 
SET 
    [Аудитория] = 'G153',
    [Номер лекции] = 53
WHERE 
    [Номер пары] = 1;

	DELETE FROM [Аудитории] 
WHERE [Номер пары] = 1;

--5
CREATE VIEW [Дисциплины] AS
SELECT TOP 150
Speciality AS [Дисциплина],
Faculty AS [Факультет]
FROM Groups
ORDER BY Дисциплина

--6
    DROP VIEW [Количество кафедр];

CREATE VIEW [Количество кафедр] WITH SCHEMABINDING AS
SELECT 
    Faculty AS [Факультет],
    Speciality AS [Специальность],
    Department AS [Кафедра],
    COUNT_BIG(*) OVER (PARTITION BY Faculty, Speciality) AS [Количество кафедр]
FROM dbo.Groups;
GO

--6.1 Проверка
ALTER TABLE dbo.Groups DROP COLUMN Faculty;
DROP TABLE dbo.Groups;

--7
-- Создаем представление с PIVOT для отображения расписания
DROP VIEW [Расписание_PIVOT]



CREATE VIEW [Расписание_PIVOT] AS
SELECT 
    'Group ' + CAST(GroupID AS VARCHAR(10)) AS [Группа],
    LessonNumber AS [Пара],
    [Monday] AS [Пн],
    [Tuesday] AS [Вт],
    [Wednesday] AS [Ср],
    [Thursday] AS [Чт],
    [Friday] AS [Пт],
    [Saturday] AS [Сб]
FROM 
(
    SELECT 
        GroupID,
        LessonNumber,
        DayOfWeek,
        Auditorium
    FROM TIMETABLE
) AS SourceTable
PIVOT
(
    MAX(Auditorium)
    FOR DayOfWeek IN ([Monday], [Tuesday], [Wednesday], [Thursday], [Friday], [Saturday])
) AS PivotTable;
GO

-- 7.1 Проверка
SELECT * FROM [Расписание_PIVOT] ORDER BY [Группа], [Пара];