USE master
CREATE DATABASE Univer
ON PRIMARY
(
    NAME = N'primary',
    FILENAME = N'C:\BD\UNIVER.mdf',
    SIZE = 10240KB,
    MAXSIZE = UNLIMITED,
    FILEGROWTH = 1024KB
),
FILEGROUP FG1
(
    NAME = N'Group_1',
    FILENAME = N'C:\BD\UNIVER_Group_1.ndf',
    SIZE = 10240KB,
    MAXSIZE = 1GB,
    FILEGROWTH = 25%
),
(
    NAME = N'Group_2',
    FILENAME = N'C:\BD\UNIVER_Group_2.ndf',
    SIZE = 10240KB,
    MAXSIZE = 1GB,
    FILEGROWTH = 25%
)

LOG ON
(
    NAME = N'log',
    FILENAME = N'C:\BD\log.ldf',
    SIZE = 10240KB,
    MAXSIZE = 2048GB,
    FILEGROWTH = 10%
)
GO