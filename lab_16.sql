--��� 16

-- 1. ������� ��������� ���� ������ ��� ������
USE master;
GO

IF EXISTS (SELECT name FROM sys.databases WHERE name = 'X_MyBASE_TEMP')
    DROP DATABASE X_MyBASE_TEMP;
GO

CREATE DATABASE X_MyBASE_TEMP;
GO

USE X_MyBASE_TEMP;
GO

-- 2. ������ �������������� ���������� SELECT-������� � ������ XML (������ 1 ������������)
-- ������� ��������� ������� ��� ������������
CREATE TABLE #Products (
    ProductID INT PRIMARY KEY,
    ProductName NVARCHAR(50),
    Price MONEY,
    Quantity INT
);

-- ��������� �������
INSERT INTO #Products VALUES 
(1, '����', 40, 5),
(2, '����', 10, 3),
(3, '����', 400, 1);

-- ������� ������ ������� FOR XML
-- ����� RAW
SELECT * FROM #Products FOR XML RAW;
GO

-- ����� AUTO
SELECT * FROM #Products FOR XML AUTO;
GO

-- ����� PATH
SELECT 
    ProductID AS '@ID',
    ProductName AS 'Name',
    Price AS 'Price',
    Quantity AS 'Quantity'
FROM #Products 
FOR XML PATH('Product'), ROOT('Products');
GO

-- 3. ������ �������������� XML-��������� � ������ ������� (������ 3 ������������)
DECLARE @h INT = 0;
DECLARE @x VARCHAR(2000) = '<?xml version="1.0" encoding="windows-1251"?>
<������>
    <����� ��������="����" ����="40" ����������="5"/>
    <����� ��������="����" ����="10" ����������="3"/>
    <����� ��������="����" ����="400" ����������="1"/>
</������>';

-- ������� ��������� ������� ��� �����������
CREATE TABLE #TempGoods (
    �������� NVARCHAR(20),
    ���� REAL,
    ���������� INT
);

-- �������������� XML ��������
EXEC sp_xml_preparedocument @h OUTPUT, @x;

-- ��������� ������ �� XML �� ��������� �������
INSERT INTO #TempGoods
SELECT * FROM OPENXML(@h, '/������/�����', 0)
WITH (
    [��������] NVARCHAR(20) '@��������',
    [����] REAL '@����',
    [����������] INT '@����������'
);

-- ������������� ����������
SELECT * FROM #TempGoods;

-- ������� XML �������� �� ������
EXEC sp_xml_removedocument @h;
GO

-- 4. ������ � XML-����� ������ (������ 4 ������������)
-- ������� ��������� ������� ����������
CREATE TABLE #���������� (
    ����������� NVARCHAR(50) PRIMARY KEY,
    ����� XML
);

-- ��������� ������ � XML
INSERT INTO #���������� (�����������, �����) 
VALUES ('���������', '<�����>
    <������>��������</������>
    <�����>�����</�����>
    <�����>������</�����>
    <���>52</���>
</�����>');

INSERT INTO #���������� (�����������, �����) 
VALUES ('���������', '<�����>
    <������>��������</������>
    <�����>�����</�����>
    <�����>�������������</�����>
    <���>35</���>
</�����>');

-- ��������� ������ � XML
UPDATE #����������
SET ����� = '<�����>
    <������>��������</������>
    <�����>�����</�����>
    <�����>�������������</�����>
    <���>45</���>
</�����>'
WHERE �����.value('(/�����/���)[1]', 'varchar(10)') = '35';

-- �������� ������ � �������������� XML �������
SELECT 
    �����������,
    �����.value('(/�����/������)[1]', 'varchar(10)') AS ������,
    �����.query('/�����') AS �����
FROM #����������;
GO

-- 5. ������ � XML Schema Collection (������ 5 ������������)
-- ������� XML Schema Collection
CREATE XML SCHEMA COLLECTION Student AS N'<?xml version="1.0" encoding="utf-16"?>
<xs:schema attributeFormDefault="unqualified" elementFormDefault="qualified" xmlns:xs="http://www.w3.org/2001/XMLSchema">
    <xs:element name="�������">
        <xs:complexType>
            <xs:sequence>
                <xs:element name="�������" maxOccurs="1" minOccurs="1">
                    <xs:complexType>
                        <xs:attribute name="�����" type="xs:string" use="required"/>
                        <xs:attribute name="�����" type="xs:unsignedInt" use="required"/>
                        <xs:attribute name="����" use="required">
                            <xs:simpleType>
                                <xs:restriction base="xs:string">
                                    <xs:pattern value="[0-9]{2}.[0-9]{2}.[0-9]{4}"/>
                                </xs:restriction>
                            </xs:simpleType>
                        </xs:attribute>
                    </xs:complexType>
                </xs:element>
                <xs:element maxOccurs="3" name="�������" type="xs:unsignedInt"/>
                <xs:element name="�����">
                    <xs:complexType>
                        <xs:sequence>
                            <xs:element name="������" type="xs:string"/>
                            <xs:element name="�����" type="xs:string"/>
                            <xs:element name="�����" type="xs:string"/>
                            <xs:element name="���" type="xs:string"/>
                            <xs:element name="��������" type="xs:string"/>
                        </xs:sequence>
                    </xs:complexType>
                </xs:element>
            </xs:sequence>
        </xs:complexType>
    </xs:element>
</xs:schema>';
GO

-- ������� ��������� ������� STUDENT � �������������� XML
CREATE TABLE #STUDENT (
    IDSTUDENT INT IDENTITY(1000,1) PRIMARY KEY,
    NAME NVARCHAR(100),
    BDAY DATE,
    INFO XML(Student)  -- �������������� ������� XML-����
);

-- ��������� ������ � �������� XML
INSERT INTO #STUDENT (NAME, BDAY, INFO) 
VALUES ('������ �.�.', '1995-05-15', 
'<�������>
    <������� �����="��" �����="1234567" ����="01.01.2010"/>
    <�������>1234567</�������>
    <�������>7654321</�������>
    <�����>
        <������>��������</������>
        <�����>�����</�����>
        <�����>������</�����>
        <���>10</���>
        <��������>15</��������>
    </�����>
</�������>');

-- ������������� ������
SELECT * FROM #STUDENT;
GO

-- 6. ����������� �������� ��� ���� ������ X_MyBASE (������ 6 ������������)
-- ������� ��������� ������� ��� ������������
CREATE TABLE #���������� (
    ���_���������� INT PRIMARY KEY,
    �������� NVARCHAR(50)
);

CREATE TABLE #������� (
    ���_������� INT PRIMARY KEY,
    ���_���������� INT REFERENCES #����������(���_����������),
    �������� NVARCHAR(50)
);

CREATE TABLE #������������� (
    ���_������������� INT PRIMARY KEY,
    ���_������� INT REFERENCES #�������(���_�������),
    ��� NVARCHAR(100),
    ��������� NVARCHAR(50)
);

-- ��������� �������
INSERT INTO #���������� VALUES 
(1, '��������� �������������� ����������'),
(2, '������������� ���������');

INSERT INTO #������� VALUES 
(101, 1, '������� ������������ �����������'),
(102, 1, '������� ������������ ������'),
(201, 2, '������� ���������');

INSERT INTO #������������� VALUES 
(1001, 101, '������ �.�.', '������'),
(1002, 101, '������� �.�.', '���������'),
(1003, 102, '������� �.�.', '������� �������������'),
(1004, 201, '������� �.�.', '������');

-- 7. SELECT-������, ����������� XML-�������� � ��������� ��������� ���� (������ 7 ������������)
SELECT 
    f.���_���������� AS '@���',
    f.�������� AS '@��������',
    (SELECT 
        k.���_������� AS '@���',
        k.�������� AS '@��������',
        (SELECT 
            p.���_������������� AS '@���',
            p.��� AS '@���',
            p.��������� AS '@���������'
        FROM #������������� p
        WHERE p.���_������� = k.���_�������
        FOR XML PATH('�������������'), TYPE) AS '�������/�������������'
    FROM #������� k
    WHERE k.���_���������� = f.���_����������
    FOR XML PATH('�������'), TYPE) AS '���������/�������'
FROM #���������� f
FOR XML PATH('���������'), ROOT('�����������');
GO

-- ������� ��������� ��������
DROP TABLE #Products;
DROP TABLE #TempGoods;
DROP TABLE #����������;
DROP TABLE #STUDENT;
DROP TABLE #�������������;
DROP TABLE #�������;
DROP TABLE #����������;
GO

USE master;
GO
DROP DATABASE X_MyBASE_TEMP;
GO