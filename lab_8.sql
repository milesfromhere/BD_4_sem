--1
--SELECT Speciality [�������������],Department [�������],StudentCount [����������� ���������]from Groups

CREATE VIEW [������]
AS SELECT Speciality [�������������],
Department [�������],
StudentCount [����������� ���������]
from Groups

--DROP VIEW [������]

ALTER VIEW [������]
AS SELECT 
Department [�������],

Speciality [�������������],

StudentCount [����������� ���������]
from Groups
--1.1 
CREATE VIEW [������] AS SELECT * FROM Groups;

SELECT * FROM [������] ORDER BY [����������� ���������];

SELECT * FROM [������] WHERE [�������] = 'Technical Department';

--2
CREATE VIEW [���������� ������] AS
SELECT 
    Faculty AS [���������],
    Speciality AS [�������������],
    Department AS [�������],
    COUNT(*) OVER (PARTITION BY Faculty, Speciality) AS [���������� ������]
FROM Groups;

--DROP VIEW [���������� ������]

--2.1

ALTER VIEW [���������� ������] AS
SELECT 
    GroupNumber AS [����� ������], 
    Department AS [�������],
    Speciality AS [�������������],
    Faculty AS [���������],
    StudentCount AS [���-�� ���������] 
FROM Groups;

-- ������� ����� ������
INSERT INTO [���������� ������] ([����� ������],[�������], [�������������], [���������], [���-�� ���������])
VALUES ('G152','����� �������', '����� �������������', '���������', 52);

-- ���������� ������
UPDATE [���������� ������]
SET [���������] = '����� ���������'
WHERE [�������] = '����� �������';

-- �������� ������
DELETE FROM [���������� ������]
WHERE [�������] = '����� �������';

--3
CREATE VIEW [���������]
AS SELECT
TimetableID as [����� ����],
Auditorium as [���������],
LessonNumber as [����� ������]
FROM TIMETABLE;

--DROP VIEW [���������]

--3.1

ALTER VIEW [���������] AS
SELECT
    TimetableID as [����� ����],
    Auditorium as [���������],
    LessonNumber as [����� ������],
    TeacherID as [�������������],
    GroupID as [������],
    CourseID as [ID �����],
    DayOfWeek as [���� ������]
FROM TIMETABLE;

INSERT INTO [���������] ([���������],[����� ������],[�������������],[������],[ID �����],[���� ������])
VALUES ('G101',52, 1, 1, 5, 'Monday');

UPDATE [���������] 
SET 
    [���������] = 'G153',
    [����� ������] = 53
WHERE 
    [����� ����] = 1;

	DELETE FROM [���������] 
WHERE [����� ����] = 1;

--4
CREATE VIEW [���������]
AS SELECT
TimetableID as [����� ����],
Auditorium as [���������],
LessonNumber as [����� ������]
FROM TIMETABLE where LessonNumber >1 WITH CHECK OPTION;

--DROP VIEW [���������]

--4.1

ALTER VIEW [���������] AS
SELECT
    TimetableID as [����� ����],
    Auditorium as [���������],
    LessonNumber as [����� ������],
    TeacherID as [�������������],
    GroupID as [������],
    CourseID as [ID �����],
    DayOfWeek as [���� ������]
FROM TIMETABLE where LessonNumber >1 WITH CHECK OPTION;

INSERT INTO [���������] ([���������],[����� ������],[�������������],[������],[ID �����],[���� ������])
VALUES ('G101',52, 10, 1, 5, 'Monday');

UPDATE [���������] 
SET 
    [���������] = 'G153',
    [����� ������] = 53
WHERE 
    [����� ����] = 1;

	DELETE FROM [���������] 
WHERE [����� ����] = 1;

--5
CREATE VIEW [����������] AS
SELECT TOP 150
Speciality AS [����������],
Faculty AS [���������]
FROM Groups
ORDER BY ����������

--6
    DROP VIEW [���������� ������];

CREATE VIEW [���������� ������] WITH SCHEMABINDING AS
SELECT 
    Faculty AS [���������],
    Speciality AS [�������������],
    Department AS [�������],
    COUNT_BIG(*) OVER (PARTITION BY Faculty, Speciality) AS [���������� ������]
FROM dbo.Groups;
GO

--6.1 ��������
ALTER TABLE dbo.Groups DROP COLUMN Faculty;
DROP TABLE dbo.Groups;

--7
-- ������� ������������� � PIVOT ��� ����������� ����������
DROP VIEW [����������_PIVOT]



CREATE VIEW [����������_PIVOT] AS
SELECT 
    'Group ' + CAST(GroupID AS VARCHAR(10)) AS [������],
    LessonNumber AS [����],
    [Monday] AS [��],
    [Tuesday] AS [��],
    [Wednesday] AS [��],
    [Thursday] AS [��],
    [Friday] AS [��],
    [Saturday] AS [��]
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

-- 7.1 ��������
SELECT * FROM [����������_PIVOT] ORDER BY [������], [����];