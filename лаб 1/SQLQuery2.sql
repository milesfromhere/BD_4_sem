CREATE TABLE "ЗАКАЗЧИКИ" 
(
"Наименование_фирмы" nvarchar(20),
"Адрес" nvarchar(50),
"Расчетный_счёт" nvarchar(15),
)

CREATE TABLE "ТОВАРЫ"
(
"Наименование" nvarchar(20),
"Цена" real,
"Количество" int
)

CREATE TABLE "ЗАКАЗЫ" 
(
"Номер_заказа" nvarchar(10),
"Наименование_товара" nvarchar(20),
"Цена_продажи" real,
"Количество" int,
Дата_поставки date,
Заказчик nvarchar(20),
)

INSERT INTO ЗАКАЗЧИКИ (Наименование_фирмы, Адрес, Расчетный_счёт)
VALUES 
('FirstCompany', 'Main Street, 10', '123456789012345'),
('SecondCompany', 'Lenin Avenue, 20', '234567890123456'),
('ThirdCompany', 'Soviet Street, 30', '345678901234567'),
('FourthCompany', 'Liberty Square, 40', '456789012345678'),
('FifthCompany', 'Industrial Road, 50', '567890123456789');

INSERT INTO ТОВАРЫ (Наименование, Цена, Количество)
VALUES 
('Product1', 500.0, 10),
('Product2', 1200.0, 5),
('Product3', 300.0, 20),
('Product4', 800.0, 7),
('Product5', 450.0, 15);

INSERT INTO ЗАКАЗЫ (Номер_заказа, Наименование_товара, Цена_продажи, Количество, Дата_поставки, Заказчик)
VALUES 
('001', 'Item1', 500.0, 10, '2025-02-01', 'FirstCompany'),
('002', 'Item2', 1200.0, 5, '2025-02-05', 'SecondCompany'),
('003', 'Item3', 300.0, 20, '2025-02-10', 'ThirdCompany'),
('004', 'Item4', 800.0, 7, '2025-02-15', 'FourthCompany'),
('005', 'Item5', 450.0, 15, '2025-02-20', 'FifthCompany');