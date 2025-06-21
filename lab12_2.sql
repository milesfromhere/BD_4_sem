-- Транзакция B: Изменение данных
-- Откройте это во втором окне соединения с SQL Server сразу после запуска транзакции A
BEGIN TRANSACTION;

UPDATE Courses 
SET Payment = Payment * 1.1 
WHERE CourseName = 'Python Programming';

ROLLBACK TRANSACTION;
-- Транзакция B: Изменение данных
-- Откройте это во втором окне соединения с SQL Server сразу после запуска транзакции A
BEGIN TRANSACTION;

UPDATE Courses 
SET Payment = Payment * 1.1 
WHERE CourseName = 'Python Programming';

ROLLBACK TRANSACTION;



----------5
-- Транзакция B: Изменение данных
BEGIN TRANSACTION;

UPDATE Teachers 
SET Experience = Experience + 1 
WHERE LastName = 'Doe';

COMMIT TRANSACTION;

BEGIN TRANSACTION;
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;

SELECT 'Transaction A ', * FROM Groups WHERE StudentCount > 25;

SELECT 'Transaction A ', * FROM Groups WHERE StudentCount > 25;

COMMIT TRANSACTION;
