--лаб 16

-- 1. Создаем временную базу данных для работы
USE master;
GO

IF EXISTS (SELECT name FROM sys.databases WHERE name = 'X_MyBASE_TEMP')
    DROP DATABASE X_MyBASE_TEMP;
GO

CREATE DATABASE X_MyBASE_TEMP;
GO

USE X_MyBASE_TEMP;
GO

-- 2. Пример преобразования результата SELECT-запроса в формат XML (раздел 1 лабораторной)
-- Создаем временную таблицу для демонстрации
CREATE TABLE #Products (
    ProductID INT PRIMARY KEY,
    ProductName NVARCHAR(50),
    Price MONEY,
    Quantity INT
);

-- Заполняем данными
INSERT INTO #Products VALUES 
(1, 'Стол', 40, 5),
(2, 'Стул', 10, 3),
(3, 'Шкаф', 400, 1);

-- Примеры разных режимов FOR XML
-- Режим RAW
SELECT * FROM #Products FOR XML RAW;
GO

-- Режим AUTO
SELECT * FROM #Products FOR XML AUTO;
GO

-- Режим PATH
SELECT 
    ProductID AS '@ID',
    ProductName AS 'Name',
    Price AS 'Price',
    Quantity AS 'Quantity'
FROM #Products 
FOR XML PATH('Product'), ROOT('Products');
GO

-- 3. Пример преобразования XML-структуры в строки таблицы (раздел 3 лабораторной)
DECLARE @h INT = 0;
DECLARE @x VARCHAR(2000) = '<?xml version="1.0" encoding="windows-1251"?>
<товары>
    <товар название="стол" цена="40" количество="5"/>
    <товар название="стул" цена="10" количество="3"/>
    <товар название="шкаф" цена="400" количество="1"/>
</товары>';

-- Создаем временную таблицу для результатов
CREATE TABLE #TempGoods (
    Название NVARCHAR(20),
    Цена REAL,
    Количество INT
);

-- Подготавливаем XML документ
EXEC sp_xml_preparedocument @h OUTPUT, @x;

-- Вставляем данные из XML во временную таблицу
INSERT INTO #TempGoods
SELECT * FROM OPENXML(@h, '/товары/товар', 0)
WITH (
    [Название] NVARCHAR(20) '@название',
    [Цена] REAL '@цена',
    [Количество] INT '@количество'
);

-- Просматриваем результаты
SELECT * FROM #TempGoods;

-- Удаляем XML документ из памяти
EXEC sp_xml_removedocument @h;
GO

-- 4. Работа с XML-типом данных (раздел 4 лабораторной)
-- Создаем временную таблицу Поставщики
CREATE TABLE #Поставщики (
    Организация NVARCHAR(50) PRIMARY KEY,
    Адрес XML
);

-- Вставляем данные с XML
INSERT INTO #Поставщики (Организация, Адрес) 
VALUES ('Пинскдрев', '<адрес>
    <страна>Беларусь</страна>
    <город>Пинск</город>
    <улица>Кирова</улица>
    <дом>52</дом>
</адрес>');

INSERT INTO #Поставщики (Организация, Адрес) 
VALUES ('Минскдрев', '<адрес>
    <страна>Беларусь</страна>
    <город>Минск</город>
    <улица>Кальварийская</улица>
    <дом>35</дом>
</адрес>');

-- Обновляем данные в XML
UPDATE #Поставщики
SET Адрес = '<адрес>
    <страна>Беларусь</страна>
    <город>Минск</город>
    <улица>Кальварийская</улица>
    <дом>45</дом>
</адрес>'
WHERE Адрес.value('(/адрес/дом)[1]', 'varchar(10)') = '35';

-- Выбираем данные с использованием XML методов
SELECT 
    Организация,
    Адрес.value('(/адрес/страна)[1]', 'varchar(10)') AS Страна,
    Адрес.query('/адрес') AS Адрес
FROM #Поставщики;
GO

-- 5. Работа с XML Schema Collection (раздел 5 лабораторной)
-- Создаем XML Schema Collection
CREATE XML SCHEMA COLLECTION Student AS N'<?xml version="1.0" encoding="utf-16"?>
<xs:schema attributeFormDefault="unqualified" elementFormDefault="qualified" xmlns:xs="http://www.w3.org/2001/XMLSchema">
    <xs:element name="студент">
        <xs:complexType>
            <xs:sequence>
                <xs:element name="паспорт" maxOccurs="1" minOccurs="1">
                    <xs:complexType>
                        <xs:attribute name="серия" type="xs:string" use="required"/>
                        <xs:attribute name="номер" type="xs:unsignedInt" use="required"/>
                        <xs:attribute name="дата" use="required">
                            <xs:simpleType>
                                <xs:restriction base="xs:string">
                                    <xs:pattern value="[0-9]{2}.[0-9]{2}.[0-9]{4}"/>
                                </xs:restriction>
                            </xs:simpleType>
                        </xs:attribute>
                    </xs:complexType>
                </xs:element>
                <xs:element maxOccurs="3" name="телефон" type="xs:unsignedInt"/>
                <xs:element name="адрес">
                    <xs:complexType>
                        <xs:sequence>
                            <xs:element name="страна" type="xs:string"/>
                            <xs:element name="город" type="xs:string"/>
                            <xs:element name="улица" type="xs:string"/>
                            <xs:element name="дом" type="xs:string"/>
                            <xs:element name="квартира" type="xs:string"/>
                        </xs:sequence>
                    </xs:complexType>
                </xs:element>
            </xs:sequence>
        </xs:complexType>
    </xs:element>
</xs:schema>';
GO

-- Создаем временную таблицу STUDENT с типизированным XML
CREATE TABLE #STUDENT (
    IDSTUDENT INT IDENTITY(1000,1) PRIMARY KEY,
    NAME NVARCHAR(100),
    BDAY DATE,
    INFO XML(Student)  -- типизированный столбец XML-типа
);

-- Вставляем данные с валидным XML
INSERT INTO #STUDENT (NAME, BDAY, INFO) 
VALUES ('Иванов И.И.', '1995-05-15', 
'<студент>
    <паспорт серия="МР" номер="1234567" дата="01.01.2010"/>
    <телефон>1234567</телефон>
    <телефон>7654321</телефон>
    <адрес>
        <страна>Беларусь</страна>
        <город>Минск</город>
        <улица>Ленина</улица>
        <дом>10</дом>
        <квартира>15</квартира>
    </адрес>
</студент>');

-- Просматриваем данные
SELECT * FROM #STUDENT;
GO

-- 6. Разработать сценарии для базы данных X_MyBASE (раздел 6 лабораторной)
-- Создаем временные таблицы для демонстрации
CREATE TABLE #Факультеты (
    Код_факультета INT PRIMARY KEY,
    Название NVARCHAR(50)
);

CREATE TABLE #Кафедры (
    Код_кафедры INT PRIMARY KEY,
    Код_факультета INT REFERENCES #Факультеты(Код_факультета),
    Название NVARCHAR(50)
);

CREATE TABLE #Преподаватели (
    Код_преподавателя INT PRIMARY KEY,
    Код_кафедры INT REFERENCES #Кафедры(Код_кафедры),
    ФИО NVARCHAR(100),
    Должность NVARCHAR(50)
);

-- Заполняем данными
INSERT INTO #Факультеты VALUES 
(1, 'Факультет информационных технологий'),
(2, 'Экономический факультет');

INSERT INTO #Кафедры VALUES 
(101, 1, 'Кафедра программного обеспечения'),
(102, 1, 'Кафедра компьютерных систем'),
(201, 2, 'Кафедра экономики');

INSERT INTO #Преподаватели VALUES 
(1001, 101, 'Петров П.П.', 'Доцент'),
(1002, 101, 'Иванова И.И.', 'Профессор'),
(1003, 102, 'Сидоров С.С.', 'Старший преподаватель'),
(1004, 201, 'Козлова К.К.', 'Доцент');

-- 7. SELECT-запрос, формирующий XML-фрагмент с описанием структуры вуза (раздел 7 лабораторной)
SELECT 
    f.Код_факультета AS '@Код',
    f.Название AS '@Название',
    (SELECT 
        k.Код_кафедры AS '@Код',
        k.Название AS '@Название',
        (SELECT 
            p.Код_преподавателя AS '@Код',
            p.ФИО AS '@ФИО',
            p.Должность AS '@Должность'
        FROM #Преподаватели p
        WHERE p.Код_кафедры = k.Код_кафедры
        FOR XML PATH('Преподаватель'), TYPE) AS 'Кафедра/Преподаватели'
    FROM #Кафедры k
    WHERE k.Код_факультета = f.Код_факультета
    FOR XML PATH('Кафедра'), TYPE) AS 'Факультет/Кафедры'
FROM #Факультеты f
FOR XML PATH('Факультет'), ROOT('Университет');
GO

-- Очистка временных объектов
DROP TABLE #Products;
DROP TABLE #TempGoods;
DROP TABLE #Поставщики;
DROP TABLE #STUDENT;
DROP TABLE #Преподаватели;
DROP TABLE #Кафедры;
DROP TABLE #Факультеты;
GO

USE master;
GO
DROP DATABASE X_MyBASE_TEMP;
GO