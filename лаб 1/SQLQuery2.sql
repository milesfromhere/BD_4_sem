CREATE TABLE "���������" 
(
"������������_�����" nvarchar(20),
"�����" nvarchar(50),
"���������_����" nvarchar(15),
)

CREATE TABLE "������"
(
"������������" nvarchar(20),
"����" real,
"����������" int
)

CREATE TABLE "������" 
(
"�����_������" nvarchar(10),
"������������_������" nvarchar(20),
"����_�������" real,
"����������" int,
����_�������� date,
�������� nvarchar(20),
)

INSERT INTO ��������� (������������_�����, �����, ���������_����)
VALUES 
('FirstCompany', 'Main Street, 10', '123456789012345'),
('SecondCompany', 'Lenin Avenue, 20', '234567890123456'),
('ThirdCompany', 'Soviet Street, 30', '345678901234567'),
('FourthCompany', 'Liberty Square, 40', '456789012345678'),
('FifthCompany', 'Industrial Road, 50', '567890123456789');

INSERT INTO ������ (������������, ����, ����������)
VALUES 
('Product1', 500.0, 10),
('Product2', 1200.0, 5),
('Product3', 300.0, 20),
('Product4', 800.0, 7),
('Product5', 450.0, 15);

INSERT INTO ������ (�����_������, ������������_������, ����_�������, ����������, ����_��������, ��������)
VALUES 
('001', 'Item1', 500.0, 10, '2025-02-01', 'FirstCompany'),
('002', 'Item2', 1200.0, 5, '2025-02-05', 'SecondCompany'),
('003', 'Item3', 300.0, 20, '2025-02-10', 'ThirdCompany'),
('004', 'Item4', 800.0, 7, '2025-02-15', 'FourthCompany'),
('005', 'Item5', 450.0, 15, '2025-02-20', 'FifthCompany');