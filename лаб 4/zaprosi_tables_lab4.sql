-- ���������� ������ FACULTY � PULPIT
SELECT F.FACULTY_NAME, P.PULPIT_NAME
FROM FACULTY F
INNER JOIN PULPIT P ON F.FACULTY = P.FACULTY;

-- ���������� ������ TEACHER � PULPIT � ����������� �� �������
SELECT T.TEACHER_NAME, P.PULPIT_NAME
FROM TEACHER T
INNER JOIN PULPIT P ON T.PULPIT = P.PULPIT
WHERE P.PULPIT_NAME LIKE '%Informacionnyh%';

-- ������������� ��������� �� �����������
SELECT 
    AUDITORIUM,
    AUDITORIUM_NAME,
    AUDITORIUM_CAPACITY,
    CASE
        WHEN AUDITORIUM_CAPACITY < 20 THEN '�����'
        WHEN AUDITORIUM_CAPACITY BETWEEN 20 AND 50 THEN '�������'
        WHEN AUDITORIUM_CAPACITY > 50 THEN '�������'
        ELSE '�� ����������'
    END AS '��� �� �����������'
FROM AUDITORIUM;

-- ��� ������� � ������������� (���� ���� �� ������� ��� ��������������)
SELECT P.PULPIT_NAME, T.TEACHER_NAME
FROM PULPIT P
LEFT OUTER JOIN TEACHER T ON P.PULPIT = T.PULPIT;

-- ��� �������� � �� ������ (���� ���� ������ ���)
SELECT S.NAME, P.NOTE, P.PDATE
FROM STUDENT S
LEFT OUTER JOIN PROGRESS P ON S.IDSTUDENT = P.IDSTUDENT;

-- ������ ���������� ������ SUBJECT � PROGRESS
SELECT 
    S.SUBJECT_NAME,
    P.NOTE,
    P.PDATE
FROM SUBJECT S
FULL OUTER JOIN PROGRESS P ON S.SUBJECT = P.SUBJECT;

-- ���������� ����������� ������� ����� STUDENT � PROGRESS
SELECT 
    COUNT(*) AS �����������_������
FROM STUDENT S
FULL OUTER JOIN PROGRESS P ON S.IDSTUDENT = P.IDSTUDENT
WHERE S.IDSTUDENT IS NULL OR P.IDSTUDENT IS NULL;

-- ��������� ������������ ����� ��������� � �����������
SELECT 
    AT.AUDITORIUM_TYPENAME,
    F.FACULTY_NAME
FROM AUDITORIUM_TYPE AT
CROSS JOIN FACULTY F;

-- ������� ���� �� ���������
SELECT 
    S.SUBJECT_NAME,
    AVG(P.NOTE) AS �������_����
FROM SUBJECT S
LEFT JOIN PROGRESS P ON S.SUBJECT = P.SUBJECT
GROUP BY S.SUBJECT_NAME;

-- ���������� ��������� �� �����������
SELECT 
    F.FACULTY_NAME,
    COUNT(S.IDSTUDENT) AS ����������_���������
FROM FACULTY F
LEFT JOIN GROUPS G ON F.FACULTY = G.FACULTY
LEFT JOIN STUDENT S ON G.IDGROUP = S.IDGROUP
GROUP BY F.FACULTY_NAME;

