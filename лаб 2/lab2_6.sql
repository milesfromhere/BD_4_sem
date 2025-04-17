--1. Таблица Departments (Отделы)
CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY IDENTITY(1,1),
    DepartmentName NVARCHAR(100) NOT NULL,
    EmployeeCount INT NOT NULL
);

INSERT INTO Departments (DepartmentName, EmployeeCount)
VALUES 
('IT Department', 10),
('HR Department', 5),
('Sales Department', 8),
('Marketing Department', 7),
('Finance Department', 6);
--2. Таблица Items (Товары)
CREATE TABLE Items (
    ItemID INT PRIMARY KEY IDENTITY(1,1),
    ItemName NVARCHAR(100) NOT NULL,
    Description NVARCHAR(255),
    SpendingLimit DECIMAL(10, 2) NOT NULL
);

INSERT INTO Items (ItemName, Description, SpendingLimit)
VALUES 
('USB Flash Drive', '32GB USB 3.0 Flash Drive', 50.00),
('Notebooks', 'A4 size, 100 sheets', 30.00),
('Pens', 'Ballpoint pens, pack of 50', 20.00),
('Markers', 'Whiteboard markers, set of 4', 40.00),
('Stapler', 'Heavy-duty stapler', 25.00);
--3. Таблица Sales (Продажи)
CREATE TABLE Sales (
    SaleID INT PRIMARY KEY IDENTITY(1,1),
    DepartmentID INT NOT NULL,
    ItemID INT NOT NULL,
    AmountSpent DECIMAL(10, 2) NOT NULL,
    PurchaseDate DATE NOT NULL,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID),
    FOREIGN KEY (ItemID) REFERENCES Items(ItemID)
);

INSERT INTO Sales (DepartmentID, ItemID, AmountSpent, PurchaseDate)
VALUES 
(1, 1, 45.00, '2023-09-01'),  -- IT Department, USB Flash Drive
(2, 2, 25.00, '2023-09-02'),  -- HR Department, Notebooks
(3, 3, 15.00, '2023-09-03'),  -- Sales Department, Pens
(4, 4, 35.00, '2023-09-04'),  -- Marketing Department, Markers
(5, 5, 22.00, '2023-09-05');  -- Finance Department, Stapler