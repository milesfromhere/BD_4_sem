ALTER TABLE Teachers ADD Возраст DATE DEFAULT GETDATE();
GO

ALTER TABLE Groups DROP COLUMN StudentCount;
GO

SELECT CourseID dcfvgbnhjmk, Hours FROM Courses;
GO

SELECT COUNT(*) AS GroupNumber FROM Groups;
GO

UPDATE Teachers SET Experience = Experience + 10 WHERE LastName = N'Smith';
GO

DELETE FROM Teachers WHERE TeacherID = 5;
GO