CREATE TABLE Groups (
    GroupID INT PRIMARY KEY IDENTITY(1,1),
    GroupNumber NVARCHAR(50) NOT NULL,
    Speciality NVARCHAR(100) NOT NULL,
    Department NVARCHAR(100) NOT NULL,
    StudentCount INT NOT NULL
);
INSERT INTO Groups (GroupNumber, Speciality, Department, StudentCount)
VALUES 
('G101', 'Computer Science', 'Technical Department', 30),
('G102', 'Mathematics', 'Science Department', 25),
('G103', 'Physics', 'Science Department', 20),
('G104', 'Engineering', 'Technical Department', 35),
('G105', 'Biology', 'Science Department', 28);

CREATE TABLE Teachers (
    TeacherID INT PRIMARY KEY IDENTITY(1,1),
    LastName NVARCHAR(50) NOT NULL,
    FirstName NVARCHAR(50) NOT NULL,
    MiddleName NVARCHAR(50),
    Phone NVARCHAR(15),
    Experience INT NOT NULL
);
INSERT INTO Teachers (LastName, FirstName, MiddleName, Phone, Experience)
VALUES 
('Smith', 'John', 'A.', '+1234567890', 5),
('Doe', 'Jane', 'B.', '+0987654321', 10),
('Brown', 'Michael', 'C.', '+1122334455', 7),
('Johnson', 'Emily', 'D.', '+5566778899', 12),
('Williams', 'David', 'E.', '+9988776655', 8);

CREATE TABLE Courses (
    CourseID INT PRIMARY KEY IDENTITY(1,1),
    CourseName NVARCHAR(100) NOT NULL,
    Hours INT NOT NULL,
    Subject NVARCHAR(100) NOT NULL,
    LessonType NVARCHAR(50) NOT NULL,
    Payment DECIMAL(10, 2) NOT NULL
);
INSERT INTO Courses (CourseName, Hours, Subject, LessonType, Payment)
VALUES 
('Python Programming', 120, 'Programming', 'Lecture', 5000.00),
('Advanced Mathematics', 90, 'Mathematics', 'Seminar', 4500.00),
('Quantum Physics', 100, 'Physics', 'Lecture', 6000.00),
('Mechanical Engineering', 150, 'Engineering', 'Lab', 7000.00),
('Genetics', 80, 'Biology', 'Lecture', 4000.00);

CREATE TABLE GroupCourses (
    GroupCourseID INT PRIMARY KEY IDENTITY(1,1),
    GroupID INT NOT NULL,
    CourseID INT NOT NULL,
    TeacherID INT NOT NULL,
    FOREIGN KEY (GroupID) REFERENCES Groups(GroupID),
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID),
    FOREIGN KEY (TeacherID) REFERENCES Teachers(TeacherID)
);
INSERT INTO GroupCourses (GroupID, CourseID, TeacherID)
VALUES 
(1, 1, 1),  
(2, 2, 2),  
(3, 3, 3),  
(4, 4, 4),  
(5, 5, 5);  

CREATE TABLE TIMETABLE (
    TimetableID INT PRIMARY KEY IDENTITY(1,1),
    GroupID INT NOT NULL,
    CourseID INT NOT NULL,
    TeacherID INT NOT NULL,
    DayOfWeek NVARCHAR(15) NOT NULL, -- 'Monday', 'Tuesday' и т.д.
    LessonNumber INT NOT NULL,        -- Номер пары (1, 2, 3...)
    Auditorium NVARCHAR(20) NOT NULL, -- Номер аудитории
    FOREIGN KEY (GroupID) REFERENCES Groups(GroupID),
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID),
    FOREIGN KEY (TeacherID) REFERENCES Teachers(TeacherID)
);
GO
INSERT INTO TIMETABLE (GroupID, CourseID, TeacherID, DayOfWeek, LessonNumber, Auditorium)
VALUES 
(1, 1, 1, 'Monday', 1, 'A101'),
(1, 1, 1, 'Wednesday', 2, 'A101'),
(2, 2, 2, 'Tuesday', 1, 'B202'),
(3, 3, 3, 'Thursday', 3, 'C303'),
(4, 4, 4, 'Friday', 2, 'D404'),
(5, 5, 5, 'Monday', 4, 'E505');