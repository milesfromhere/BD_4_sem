-- ���������� B: ��������� ������
-- �������� ��� �� ������ ���� ���������� � SQL Server ����� ����� ������� ���������� A
BEGIN TRANSACTION;

UPDATE Courses 
SET Payment = Payment * 1.1 
WHERE CourseName = 'Python Programming';

ROLLBACK TRANSACTION;
-- ���������� B: ��������� ������
-- �������� ��� �� ������ ���� ���������� � SQL Server ����� ����� ������� ���������� A
BEGIN TRANSACTION;

UPDATE Courses 
SET Payment = Payment * 1.1 
WHERE CourseName = 'Python Programming';

ROLLBACK TRANSACTION;



----------5
-- ���������� B: ��������� ������
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
