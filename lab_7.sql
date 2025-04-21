--1
SELECT CourseName, Payment, SUM(Hours)
Hours
FROM Courses
WHERE CourseName IN ('Python Programming','Advanced Mathematics')
GROUP BY CourseName, Payment;
--1,1 ROLLUP ���������� ���������� ����� � �������� �����
SELECT CourseName, Payment, SUM(Hours)
Hours
FROM Courses
WHERE CourseName IN ('Python Programming','Advanced Mathematics')
GROUP BY ROLLUP(CourseName, Payment);
--2 CUBE ����� ��������� ���������� �����
SELECT CourseName, Payment, SUM(Hours)
Hours
FROM Courses
WHERE CourseName IN ('Python Programming','Advanced Mathematics')
GROUP BY CUBE(CourseName, Payment);
--3 UNION/UNION ALL
SELECT Department, sum(StudentCount) StudentCount
FROM Groups WHERE Speciality = 'Biology'
Group by Department
UNION
SELECT Department, sum(StudentCount) StudentCount
FROM Groups WHERE Speciality = 'Biology'
Group by Department 
UNION -- �� ������� ���������
SELECT Department, sum(StudentCount) StudentCount
FROM Groups WHERE Speciality = 'Physics'
Group by Department
UNION ALL
SELECT Department, sum(StudentCount) StudentCount
FROM Groups WHERE Speciality = 'Physics'
Group by Department
--4 INTERSECT ������������ ���� �������� �������������� 

SELECT Department, SUM(StudentCount) AS StudentCount
FROM Groups 
WHERE Speciality = 'Physics'
GROUP BY Department

INTERSECT 

SELECT Department, SUM(StudentCount) AS StudentCount
FROM Groups 
WHERE Speciality = 'Physics'
GROUP BY Department

--5 EXCEPT - �������� ���� ��������
SELECT Department, sum(StudentCount) StudentCount
FROM Groups WHERE Speciality = 'Biology'
Group by Department

except 

SELECT Department, sum(StudentCount) StudentCount
FROM Groups WHERE Speciality = 'Physics'
Group by Department

--7* ��������� � �������, �����, �� ����������
SELECT 
    '1. By Group' AS SortOrder,
    'By Group' AS Level,
    GroupNumber AS Entity,
    Department,
    StudentCount AS Count
FROM Groups

UNION ALL

SELECT 
    '2. ' + Department AS SortOrder,
    'By Department' AS Level,
    Department AS Entity,
    NULL AS Department,
    SUM(StudentCount) AS Count
FROM Groups
GROUP BY Department

UNION ALL

SELECT 
    '3. Total' AS SortOrder,
    'Total' AS Level,
    'University' AS Entity,
    NULL AS Department,
    SUM(StudentCount) AS Count
FROM Groups
ORDER BY SortOrder;