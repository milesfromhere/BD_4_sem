-- Соединение таблиц FACULTY и PULPIT
SELECT F.FACULTY_NAME, P.PULPIT_NAME
FROM FACULTY F
INNER JOIN PULPIT P ON F.FACULTY = P.FACULTY;

-- Соединение таблиц TEACHER и PULPIT с фильтрацией по кафедре
SELECT T.TEACHER_NAME, P.PULPIT_NAME
FROM TEACHER T
INNER JOIN PULPIT P ON T.PULPIT = P.PULPIT
WHERE P.PULPIT_NAME LIKE '%Informacionnyh%';

-- Классификация аудиторий по вместимости
SELECT 
    AUDITORIUM,
    AUDITORIUM_NAME,
    AUDITORIUM_CAPACITY,
    CASE
        WHEN AUDITORIUM_CAPACITY < 20 THEN 'Малая'
        WHEN AUDITORIUM_CAPACITY BETWEEN 20 AND 50 THEN 'Средняя'
        WHEN AUDITORIUM_CAPACITY > 50 THEN 'Большая'
        ELSE 'Не определена'
    END AS 'Тип по вместимости'
FROM AUDITORIUM;

-- Все кафедры и преподаватели (даже если на кафедре нет преподавателей)
SELECT P.PULPIT_NAME, T.TEACHER_NAME
FROM PULPIT P
LEFT OUTER JOIN TEACHER T ON P.PULPIT = T.PULPIT;

-- Все студенты и их оценки (даже если оценок нет)
SELECT S.NAME, P.NOTE, P.PDATE
FROM STUDENT S
LEFT OUTER JOIN PROGRESS P ON S.IDSTUDENT = P.IDSTUDENT;

-- Полное соединение таблиц SUBJECT и PROGRESS
SELECT 
    S.SUBJECT_NAME,
    P.NOTE,
    P.PDATE
FROM SUBJECT S
FULL OUTER JOIN PROGRESS P ON S.SUBJECT = P.SUBJECT;

-- Количество несвязанных записей между STUDENT и PROGRESS
SELECT 
    COUNT(*) AS Несвязанные_записи
FROM STUDENT S
FULL OUTER JOIN PROGRESS P ON S.IDSTUDENT = P.IDSTUDENT
WHERE S.IDSTUDENT IS NULL OR P.IDSTUDENT IS NULL;

-- Декартово произведение типов аудиторий и факультетов
SELECT 
    AT.AUDITORIUM_TYPENAME,
    F.FACULTY_NAME
FROM AUDITORIUM_TYPE AT
CROSS JOIN FACULTY F;

-- Средний балл по предметам
SELECT 
    S.SUBJECT_NAME,
    AVG(P.NOTE) AS Средний_балл
FROM SUBJECT S
LEFT JOIN PROGRESS P ON S.SUBJECT = P.SUBJECT
GROUP BY S.SUBJECT_NAME;

-- Количество студентов на факультетах
SELECT 
    F.FACULTY_NAME,
    COUNT(S.IDSTUDENT) AS Количество_студентов
FROM FACULTY F
LEFT JOIN GROUPS G ON F.FACULTY = G.FACULTY
LEFT JOIN STUDENT S ON G.IDGROUP = S.IDGROUP
GROUP BY F.FACULTY_NAME;

