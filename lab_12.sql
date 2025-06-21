-- 1 Неявные транзакции
SET NOCOUNT ON

-- Проверяем существование временной таблицы
IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE OBJECT_ID = object_id(N'dbo.TempGroups') )
    DROP TABLE TempGroups;

DECLARE @c int, @flag char = 'c'; -- 'c' для commit, 'r' для rollback

-- Включаем режим неявной транзакции
SET IMPLICIT_TRANSACTIONS ON

--  таблица (начало транзакции)
CREATE TABLE TempGroups(
    GroupID INT,
    GroupNumber NVARCHAR(50),
    Speciality NVARCHAR(100)
);

INSERT INTO TempGroups
SELECT GroupID, GroupNumber, Speciality FROM Groups WHERE StudentCount > 25;

-- количество строк
SET @c = (SELECT COUNT(*) FROM TempGroups);
PRINT 'Lines in TempGroups: ' + CAST(@c AS VARCHAR(2));

-- Завершаем транзакцию
IF @flag = 'c' 
    COMMIT; -- фиксация
ELSE 
    ROLLBACK; -- откат изменений

-- выключение неявной транзакции
SET IMPLICIT_TRANSACTIONS OFF

-- Проверяем существование таблицы после транзакции
IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE OBJECT_ID = object_id(N'dbo.TempGroups') )
    PRINT 'Table TempGroups not found';
ELSE 
    PRINT 'Table TempGroups not found';




	-- 2  Явные транзакции с обработкой ошибок
BEGIN TRY
    BEGIN TRANSACTION;
    
    UPDATE Groups 
    SET StudentCount = StudentCount + 5 
    WHERE Department = 'Technical Department';
    
    IF EXISTS (SELECT 1 FROM Groups WHERE Department = 'Technical Department' AND StudentCount > 40)
    BEGIN
        RAISERROR('Students count is over 40', 16, 1);
    END
    
    UPDATE Groups 
    SET StudentCount = StudentCount - 3 
    WHERE Department = 'Science Department';
    
    COMMIT TRANSACTION;
    PRINT 'Transaction is done. Changes is saved.';
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;
    
    -- Выводим информацию об ошибке
    PRINT 'Error: ' + ERROR_MESSAGE();
    PRINT 'Transacrion rejected. Changes not saved.';
END CATCH;





-- 3  Транзакции с контрольными точками (SAVE TRANSACTION)
BEGIN TRANSACTION;

INSERT INTO Courses (CourseName, Hours, Subject, LessonType, Payment)
VALUES ('Database Systems', 110, 'Computer Science', 'Lecture', 5500.00);

-- Сохраняем контрольную точку
SAVE TRANSACTION AfterCourseInsert;

DECLARE @NewCourseID INT = SCOPE_IDENTITY();
DECLARE @TechGroupID INT;

SELECT @TechGroupID = GroupID FROM Groups 
WHERE Department = 'Technical Department' AND GroupNumber = 'G101';

IF @TechGroupID IS NULL
BEGIN
    ROLLBACK TRANSACTION AfterCourseInsert;
    PRINT 'Group G101 not found. Course is added, but chanjes rejected.';
END
ELSE
BEGIN
    INSERT INTO GroupCourses (GroupID, CourseID, TeacherID)
    VALUES (@TechGroupID, @NewCourseID, 1); -- TeacherID 1 - John Smith
    
    PRINT 'New Course is added to Group G101.';
END

-- Фиксируем транзакцию
COMMIT TRANSACTION;



-- 4 Transaction A: Чтение данных с уровнем изолированности READ UNCOMMITTED

BEGIN TRANSACTION;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

SELECT 'Transaction A - Before changes' [State], * FROM Courses WHERE CourseName = 'Python Programming';

SELECT * FROM Courses

SELECT 'Transaction A - After changes', * FROM Courses WHERE CourseName = 'Python Programming';

COMMIT TRANSACTION;

-- Transaction B: Изменение данных
BEGIN TRANSACTION;

UPDATE Courses 
SET Payment = Payment * 1.1 
WHERE CourseName = 'Python Programming';

ROLLBACK TRANSACTION;
-- Transaction B: Изменение данных
BEGIN TRANSACTION;

UPDATE Courses 
SET Payment = Payment * 1.1 
WHERE CourseName = 'Python Programming';

ROLLBACK TRANSACTION;



-- 5  Уровень изолированности READ COMMITTED
BEGIN TRANSACTION;
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

SELECT 'Transaction A - First redding', * FROM Teachers WHERE Experience > 5;

SELECT 'Transaction A - Second redding', * FROM Teachers WHERE Experience > 5;

COMMIT TRANSACTION;

-- Transaction B: Изменение данных
BEGIN TRANSACTION;

UPDATE Teachers 
SET Experience = Experience + 1 
WHERE LastName = 'Smith';

COMMIT TRANSACTION;

-----------------6
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
BEGIN TRANSACTION;

SELECT 'Transaction A - First redding', * FROM Groups WHERE StudentCount > 25;

SELECT 'Transaction A - Second redding', * FROM Groups WHERE StudentCount > 25;

COMMIT TRANSACTION;



-- 7 Уровень изолированности SERIALIZABLE
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
BEGIN TRANSACTION;

SELECT 'Transaction A - Monday to do list', * 
FROM TIMETABLE 
WHERE DayOfWeek = 'Monday';

INSERT INTO TIMETABLE (GroupID, CourseID, TeacherID, DayOfWeek, LessonNumber, Auditorium)
VALUES (2, 2, 2, 'Monday', 3, 'B202');

SELECT 'Transaction A - To do list After changes', * 
FROM TIMETABLE 
WHERE DayOfWeek = 'Monday';

COMMIT TRANSACTION;



-- 8 Пример вложенных транзакций для комплексного обновления данных
BEGIN TRANSACTION OuterTran;
PRINT 'OuterTran: ' + CAST(@@TRANCOUNT AS VARCHAR(2));

UPDATE Teachers 
SET Experience = Experience + 1 
WHERE TeacherID = 1;

-- Вложенная Transaction 1
BEGIN TRANSACTION InnerTran1;
PRINT 'InnerTran1: ' + CAST(@@TRANCOUNT AS VARCHAR(2));

INSERT INTO Courses (CourseName, Hours, Subject, LessonType, Payment)
VALUES ('Web Development', 100, 'Programming', 'Lab', 5200.00);

COMMIT TRANSACTION InnerTran1;
PRINT 'InnerTran1: ' + CAST(@@TRANCOUNT AS VARCHAR(2));

-- Вложенная Transaction 2
BEGIN TRANSACTION InnerTran2;
PRINT 'InnerTran2: ' + CAST(@@TRANCOUNT AS VARCHAR(2));

-- Назначаем курс группе
DECLARE @NewCourseID INT = SCOPE_IDENTITY();
INSERT INTO GroupCourses (GroupID, CourseID, TeacherID)
VALUES (1, @NewCourseID, 1);

COMMIT TRANSACTION InnerTran2;
PRINT 'after InnerTran2: ' + CAST(@@TRANCOUNT AS VARCHAR(2));

-- Проверка
IF EXISTS (SELECT 1 FROM Courses WHERE CourseName = 'Web Development')
    PRINT 'New course is added';
ELSE
BEGIN
    ROLLBACK TRANSACTION OuterTran;
    PRINT 'Error. All changes rejected.';
    RETURN;
END

COMMIT TRANSACTION OuterTran;
PRINT 'Done. Level: ' + CAST(@@TRANCOUNT AS VARCHAR(2));





-- 9 Для X_MyBase
-- Комплексный пример: перераспределение преподавателей между курсами
BEGIN TRY
    BEGIN TRANSACTION;
    
    SAVE TRANSACTION StartPoint;
    
    DELETE FROM GroupCourses 
    WHERE TeacherID = 3 AND CourseID = (SELECT CourseID FROM Courses WHERE CourseName = 'Quantum Physics');
    
    INSERT INTO GroupCourses (GroupID, CourseID, TeacherID)
    SELECT GroupID, CourseID, 4 -- Emily Johnson
    FROM GroupCourses 
    WHERE CourseID = (SELECT CourseID FROM Courses WHERE CourseName = 'Quantum Physics');
    
    DECLARE @NewCourseID INT;
    
    INSERT INTO Courses (CourseName, Hours, Subject, LessonType, Payment)
    VALUES ('Advanced Programming', 130, 'Computer Science', 'Lab', 6500.00);
    
    SET @NewCourseID = SCOPE_IDENTITY();
    
    INSERT INTO GroupCourses (GroupID, CourseID, TeacherID)
    VALUES (1, @NewCourseID, 3); 
    
    INSERT INTO TIMETABLE (GroupID, CourseID, TeacherID, DayOfWeek, LessonNumber, Auditorium)
    VALUES (1, @NewCourseID, 3, 'Thursday', 2, 'A101');
    
    IF NOT EXISTS (
        SELECT 1 FROM GroupCourses gc
        JOIN Teachers t ON gc.TeacherID = t.TeacherID
        JOIN Courses c ON gc.CourseID = c.CourseID
        WHERE t.LastName = 'Brown' AND c.CourseName = 'Advanced Programming'
    )
    BEGIN
        ROLLBACK TRANSACTION StartPoint;
        PRINT 'Error. Rollback to StartPoint.';
    END
    
    COMMIT TRANSACTION;
    PRINT 'All changes accepted.';
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;
    
    PRINT 'Error: ' + ERROR_MESSAGE();
    PRINT 'All changes saved.';
END CATCH;