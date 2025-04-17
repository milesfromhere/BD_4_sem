drop table PROGRESS
drop table STUDENT
drop table GROUPS
drop table SUBJECT
drop table TEACHER
drop table PULPIT
drop table PROFESSION
drop table FACULTY
drop table AUDITORIUM 
drop table AUDITORIUM_TYPE  

------------Создание и заполнение таблицы AUDITORIUM_TYPE 

create table AUDITORIUM_TYPE 
(    AUDITORIUM_TYPE  char(10) constraint AUDITORIUM_TYPE_PK  primary key,  
      AUDITORIUM_TYPENAME  varchar(50)       
 )
insert into AUDITORIUM_TYPE (AUDITORIUM_TYPE, AUDITORIUM_TYPENAME) values ('LK', 'Lekcionnaya');
insert into AUDITORIUM_TYPE (AUDITORIUM_TYPE, AUDITORIUM_TYPENAME) values ('LB-K', 'Kompyuterny klass');
insert into AUDITORIUM_TYPE (AUDITORIUM_TYPE, AUDITORIUM_TYPENAME) values ('LK-K', 'Lekcionnaya s ustanovlennym proektorom');
insert into AUDITORIUM_TYPE (AUDITORIUM_TYPE, AUDITORIUM_TYPENAME) values ('LB-X', 'Himicheskaya laboratoriya');
insert into AUDITORIUM_TYPE (AUDITORIUM_TYPE, AUDITORIUM_TYPENAME) values ('LB-SK', 'Specialny kompyuterny klass');
                      
-------------Создание и заполнение таблицы AUDITORIUM  
create table AUDITORIUM 
(   AUDITORIUM   char(20)  constraint AUDITORIUM_PK  primary key,              
    AUDITORIUM_TYPE     char(10) constraint AUDITORIUM_AUDITORIUM_TYPE_FK foreign key         
                      references AUDITORIUM_TYPE(AUDITORIUM_TYPE), 
   AUDITORIUM_CAPACITY  integer constraint AUDITORIUM_CAPACITY_CHECK default 1  check (AUDITORIUM_CAPACITY between 1 and 300),  
   AUDITORIUM_NAME      varchar(50)                                     
)
insert into AUDITORIUM (AUDITORIUM, AUDITORIUM_NAME, AUDITORIUM_TYPE, AUDITORIUM_CAPACITY)   
values ('206-1', '206-1','LB-K', 15);
insert into AUDITORIUM (AUDITORIUM, AUDITORIUM_NAME, AUDITORIUM_TYPE, AUDITORIUM_CAPACITY) 
values ('301-1', '301-1', 'LB-K', 15);
insert into AUDITORIUM (AUDITORIUM, AUDITORIUM_NAME, AUDITORIUM_TYPE, AUDITORIUM_CAPACITY)   
values ('236-1', '236-1', 'LK', 60);
insert into AUDITORIUM (AUDITORIUM, AUDITORIUM_NAME, AUDITORIUM_TYPE, AUDITORIUM_CAPACITY)  
values ('313-1', '313-1', 'LK-K', 60);
insert into AUDITORIUM (AUDITORIUM, AUDITORIUM_NAME, AUDITORIUM_TYPE, AUDITORIUM_CAPACITY)  
values ('324-1', '324-1', 'LK-K', 50);
insert into AUDITORIUM (AUDITORIUM, AUDITORIUM_NAME, AUDITORIUM_TYPE, AUDITORIUM_CAPACITY)   
values ('413-1', '413-1', 'LB-K', 15);
insert into AUDITORIUM (AUDITORIUM, AUDITORIUM_NAME, AUDITORIUM_TYPE, AUDITORIUM_CAPACITY) 
values ('423-1', '423-1', 'LB-K', 90);
insert into AUDITORIUM (AUDITORIUM, AUDITORIUM_NAME, AUDITORIUM_TYPE, AUDITORIUM_CAPACITY)     
values ('408-2', '408-2', 'LK', 90);

------Создание и заполнение таблицы FACULTY
create table FACULTY
(    FACULTY      char(10)   constraint FACULTY_PK primary key,
     FACULTY_NAME  varchar(50) default '???'
);
insert into FACULTY (FACULTY, FACULTY_NAME)
            values ('HTiT', 'Himicheskaya tehnologiya i tehnika');
insert into FACULTY (FACULTY, FACULTY_NAME)
            values ('LXF', 'Lesohozyaystvenny fakultet');
insert into FACULTY (FACULTY, FACULTY_NAME)
            values ('IEF', 'Inzhenerno-ekonomichesky fakultet');
insert into FACULTY (FACULTY, FACULTY_NAME)
            values ('TTLP', 'Tehnologiya i tehnika lesnoy promyshlennosti');
insert into FACULTY (FACULTY, FACULTY_NAME)
            values ('TOV', 'Tehnologiya organicheskih veschestv');
insert into FACULTY (FACULTY, FACULTY_NAME)
            values ('IT', 'Fakultet informacionnyh tehnologiy');  

------Создание и заполнение таблицы PROFESSION
create table PROFESSION
(   PROFESSION   char(20) constraint PROFESSION_PK  primary key,
    FACULTY    char(10) constraint PROFESSION_FACULTY_FK foreign key 
                    references FACULTY(FACULTY),
    PROFESSION_NAME varchar(100),    
    QUALIFICATION   varchar(50)  
);  
insert into PROFESSION(FACULTY, PROFESSION, PROFESSION_NAME, QUALIFICATION) values ('IT', '1-40 01 02', 'Informacionnye sistemy i tehnologii', 'inzhener-programmist-sistemotehnik');
insert into PROFESSION(FACULTY, PROFESSION, PROFESSION_NAME, QUALIFICATION) values ('IT', '1-47 01 01', 'Izdatelskoe delo', 'redaktor-tehnolog');
insert into PROFESSION(FACULTY, PROFESSION, PROFESSION_NAME, QUALIFICATION) values ('IT', '1-36 06 01', 'Poligraficheskoe oborudovanie i sistemy obrabotki informacii', 'inzhener-elektromehanik');                     
insert into PROFESSION(FACULTY, PROFESSION, PROFESSION_NAME, QUALIFICATION) values ('HTiT', '1-36 01 08', 'Konstruirovanie i proizvodstvo izdeliy iz kompozicionnyh materialov', 'inzhener-mehanik');
insert into PROFESSION(FACULTY, PROFESSION, PROFESSION_NAME, QUALIFICATION) values ('HTiT', '1-36 07 01', 'Mashiny i apparaty himicheskih proizvodstv i predpriyatiy stroitelnyh materialov', 'inzhener-mehanik');
insert into PROFESSION(FACULTY, PROFESSION, PROFESSION_NAME, QUALIFICATION) values ('LXF', '1-75 01 01', 'Lesnoe hozyaystvo', 'inzhener lesnogo hozyaystva');
insert into PROFESSION(FACULTY, PROFESSION, PROFESSION_NAME, QUALIFICATION) values ('LXF', '1-75 02 01', 'Sadovo-parkovoe stroitelstvo', 'inzhener sadovo-parkovogo stroitelstva');
insert into PROFESSION(FACULTY, PROFESSION, PROFESSION_NAME, QUALIFICATION) values ('LXF', '1-89 02 02', 'Turizm i prirodopolzovanie', 'specialist v sfere turizma');
insert into PROFESSION(FACULTY, PROFESSION, PROFESSION_NAME, QUALIFICATION) values ('IEF', '1-25 01 07', 'Ekonomika i upravlenie na predpriyatii', 'ekonomist-menedzher');
insert into PROFESSION(FACULTY, PROFESSION, PROFESSION_NAME, QUALIFICATION) values ('IEF', '1-25 01 08', 'BuHgaltersky uchet, analiz i audit', 'ekonomist');                      
insert into PROFESSION(FACULTY, PROFESSION, PROFESSION_NAME, QUALIFICATION) values ('TTLP', '1-36 05 01', 'Mashiny i oborudovanie lesnogo kompleksa', 'inzhener-mehanik');
insert into PROFESSION(FACULTY, PROFESSION, PROFESSION_NAME, QUALIFICATION) values ('TTLP', '1-46 01 01', 'Lesoinzhenernoe delo', 'inzhener-tehnolog');
insert into PROFESSION(FACULTY, PROFESSION, PROFESSION_NAME, QUALIFICATION) values ('TOV', '1-48 01 02', 'Himicheskaya tehnologiya organicheskih veschestv, materialov i izdeliy', 'inzhener-himik-tehnolog');                
insert into PROFESSION(FACULTY, PROFESSION, PROFESSION_NAME, QUALIFICATION) values ('TOV', '1-48 01 05', 'Himicheskaya tehnologiya pererabotki drevesiny', 'inzhener-himik-tehnolog'); 
insert into PROFESSION(FACULTY, PROFESSION, PROFESSION_NAME, QUALIFICATION) values ('TOV', '1-54 01 03', 'Fiziko-himicheskie metody i pribory kontrolya kachestva produkcii', 'inzhener po sertifikacii'); 

------Создание и заполнение таблицы PULPIT
create table PULPIT 
(   PULPIT   char(20)  constraint PULPIT_PK  primary key,
    PULPIT_NAME  varchar(100), 
    FACULTY   char(10)   constraint PULPIT_FACULTY_FK foreign key 
                     references FACULTY(FACULTY) 
);  
insert into PULPIT (PULPIT, PULPIT_NAME, FACULTY)
  values ('ISiT', 'Informacionnyh system i tehnologiy ','IT');
insert into PULPIT (PULPIT, PULPIT_NAME, FACULTY)
    values ('LV', 'Lesovodstva','LXF');          
insert into PULPIT (PULPIT, PULPIT_NAME, FACULTY)
   values ('LU', 'Lesoustroystva','LXF');           
insert into PULPIT (PULPIT, PULPIT_NAME, FACULTY)
  values ('LZiDV', 'Lesozaschity i drevesinovedeniya','LXF');                
insert into PULPIT (PULPIT, PULPIT_NAME, FACULTY)
   values ('LKiP', 'Lesnyh kultur i pochvovedeniya','LXF'); 
insert into PULPIT (PULPIT, PULPIT_NAME, FACULTY)
   values ('TiP', 'Turizma i prirodopolzovaniya','LXF');              
insert into PULPIT (PULPIT, PULPIT_NAME, FACULTY)
   values ('LPiSPS','Landshaftnogo proektirovaniya i sadovo-parkovogo stroitelstva','LXF');          
insert into PULPIT (PULPIT, PULPIT_NAME, FACULTY)
   values ('TL', 'Transporta lesa', 'TTLP');                          
insert into PULPIT (PULPIT, PULPIT_NAME, FACULTY)
   values ('LMiLZ','Lesnyh mashin i tehnologii lesozagotovok','TTLP');  
insert into PULPIT (PULPIT, PULPIT_NAME, FACULTY)
   values ('TDP','Tehnologiy derevoobrabatyvayuschih proizvodstv', 'TTLP');   
insert into PULPIT (PULPIT, PULPIT_NAME, FACULTY)
values ('TiDID','Tehnologii i dizayna izdeliy iz drevesiny','TTLP');    
insert into PULPIT (PULPIT, PULPIT_NAME, FACULTY)
values ('OH', 'Organicheskoy himii','TOV'); 
insert into PULPIT (PULPIT, PULPIT_NAME, FACULTY)
 values ('HPD','Himicheskoy pererabotki drevesiny','TOV');             
insert into PULPIT (PULPIT, PULPIT_NAME, FACULTY)
 values ('TNViOH','Tehnologii neorganicheskih veschestv i obschey himicheskoy tehnologii ','HTiT'); 
insert into PULPIT (PULPIT, PULPIT_NAME, FACULTY)
    values ('PiAH','Processov i apparatov himicheskih proizvodstv','HTiT');                                               
insert into PULPIT (PULPIT, PULPIT_NAME, FACULTY)
values ('ETiM', 'Ekonomicheskoy teorii i marketinga','IEF');   
insert into PULPIT (PULPIT, PULPIT_NAME, FACULTY)
  values ('MiEP', 'Menedzhmenta i ekonomiki prirodopolzovaniya','IEF');   
insert into PULPIT (PULPIT, PULPIT_NAME, FACULTY)
   values ('SBUAiA', 'Statistiki, buHgalterskogo ucheta, analiza i audita', 'IEF');     
             
------Создание и заполнение таблицы TEACHER
create table TEACHER
(   TEACHER    char(10)  constraint TEACHER_PK  primary key,
    TEACHER_NAME  varchar(100), 
    GENDER     char(1) CHECK (GENDER in ('m', 'ж')),
    PULPIT   char(20) constraint TEACHER_PULPIT_FK foreign key 
                     references PULPIT(PULPIT) 
);
insert into TEACHER (TEACHER, TEACHER_NAME, GENDER, PULPIT)
    values ('SMLV', 'Smelov Vladimir Vladislavovich', 'm', 'ISiT');
insert into TEACHER (TEACHER, TEACHER_NAME, GENDER, PULPIT)
    values ('DTK', 'Dyadko Aleksandr Arkadevich', 'm', 'ISiT');
insert into TEACHER (TEACHER, TEACHER_NAME, GENDER, PULPIT)
    values ('URB', 'Urbanovich Pavel Pavlovich', 'm', 'ISiT');
insert into TEACHER (TEACHER, TEACHER_NAME, GENDER, PULPIT)
    values ('GRN', 'Gurin Nikolay Ivanovich', 'm', 'ISiT');
insert into TEACHER (TEACHER, TEACHER_NAME, GENDER, PULPIT)
    values ('ZHLK', 'Zhilak Nadezhda Aleksandrovna', 'ж', 'ISiT');                     
insert into TEACHER (TEACHER, TEACHER_NAME, GENDER, PULPIT)
    values ('MRZ', 'Moroz Elena Stanislavovna', 'ж', 'ISiT');                                                                                           
insert into TEACHER (TEACHER, TEACHER_NAME, GENDER, PULPIT)
    values ('BRTSHVCH', 'Bartashevich Svyatoslav Aleksandrovich', 'm','ISiT');
insert into TEACHER (TEACHER, TEACHER_NAME, GENDER, PULPIT)
    values ('ARS', 'Arsentev Vitaliy Arsentevich', 'm', 'ISiT');                       
insert into TEACHER (TEACHER, TEACHER_NAME, GENDER, PULPIT)
    values ('NVRV', 'Neverov Aleksandr Vasilevich', 'm', 'MiEP');
insert into TEACHER (TEACHER, TEACHER_NAME, GENDER, PULPIT)
    values ('RVKCH', 'Rovkach Andrey Ivanovich', 'm', 'LV');
insert into TEACHER (TEACHER, TEACHER_NAME, GENDER, PULPIT)
    values ('DMDK', 'Demidko Marina Nikolaevna', 'ж', 'LPiSPS');
insert into TEACHER (TEACHER, TEACHER_NAME, GENDER, PULPIT)
    values ('BRG', 'Burganskaya Tatiana Minaeva', 'ж', 'LPiSPS');
insert into TEACHER (TEACHER, TEACHER_NAME, GENDER, PULPIT)
    values ('RZHK', 'Rozhkov Leonid Nikolaevich', 'm', 'LV');                      
insert into TEACHER (TEACHER, TEACHER_NAME, GENDER, PULPIT)
    values ('ZVGTSV', 'Zvyagincev Vyacheslav Borisovich', 'm', 'LZiDV'); 
insert into TEACHER (TEACHER, TEACHER_NAME, GENDER, PULPIT)
    values ('BZBRDV', 'Bezborodov Vladimir Stepanovich', 'm', 'OH'); 
insert into TEACHER (TEACHER, TEACHER_NAME, GENDER, PULPIT)
    values ('NSKVTS', 'Naskovets Mihail Trofimovich', 'm', 'TL'); 

------Создание и заполнение таблицы SUBJECT
create table SUBJECT
(     SUBJECT  char(10) constraint SUBJECT_PK  primary key, 
      SUBJECT_NAME varchar(100) unique,
      PULPIT  char(20) constraint SUBJECT_PULPIT_FK foreign key 
                     references PULPIT(PULPIT)   
)
insert into SUBJECT (SUBJECT, SUBJECT_NAME, PULPIT)
    values ('SUBD', 'Sistemy upravleniya bazami dannyh', 'ISiT');
insert into SUBJECT (SUBJECT, SUBJECT_NAME, PULPIT)
    values ('BD', 'Bazy dannyh','ISiT');
insert into SUBJECT (SUBJECT, SUBJECT_NAME, PULPIT)
    values ('INF', 'Informacionnye tehnologii','ISiT');
insert into SUBJECT (SUBJECT, SUBJECT_NAME, PULPIT)
    values ('OAiP', 'Osnovy algoritmizacii i programmirovaniya', 'ISiT');
insert into SUBJECT (SUBJECT, SUBJECT_NAME, PULPIT)
    values ('PZ', 'Predstavlenie znaniy v kompyuternyh sistemah', 'ISiT');
insert into SUBJECT (SUBJECT, SUBJECT_NAME, PULPIT)
    values ('PSP', 'Programmirovanie setevyh prilozheniy', 'ISiT');
insert into SUBJECT (SUBJECT, SUBJECT_NAME, PULPIT)
    values ('MSO', 'Modelirovanie system obrabotki informacii', 'ISiT');
insert into SUBJECT (SUBJECT, SUBJECT_NAME, PULPIT)
    values ('PIS', 'Proektirovanie informacionnyh system', 'ISiT');
insert into SUBJECT (SUBJECT, SUBJECT_NAME, PULPIT)
    values ('KG', 'Kompyuternaya geometriya ','ISiT');
insert into SUBJECT (SUBJECT, SUBJECT_NAME, PULPIT)
    values ('PMAPL', 'Poligraficheskie mashiny, avtomaty i potochnye linii', 'ISiT');
insert into SUBJECT (SUBJECT, SUBJECT_NAME, PULPIT)
    values ('KMS', 'Kompyuternye multimedijnye sistemy', 'ISiT');
insert into SUBJECT (SUBJECT, SUBJECT_NAME, PULPIT)
    values ('OPP', 'Organizaciya poligraficheskogo proizvodstva', 'ISiT');
insert into SUBJECT (SUBJECT, SUBJECT_NAME, PULPIT)
    values ('DM', 'Diskretnaya matematika', 'ISiT');
insert into SUBJECT (SUBJECT, SUBJECT_NAME,PULPIT)
    values ('MP', 'Matematicheskoe programmirovanie','ISiT');  
insert into SUBJECT (SUBJECT, SUBJECT_NAME, PULPIT)
    values ('LEVM', 'Logicheskie osnovy EVM', 'ISiT');                   
insert into SUBJECT (SUBJECT, SUBJECT_NAME,PULPIT)
    values ('OOP', 'Obektno-orientirovannoe programmirovanie', 'ISiT');
insert into SUBJECT (SUBJECT, SUBJECT_NAME, PULPIT)
    values ('EP', 'Ekonomika prirodopolzovaniya','MiEP');
insert into SUBJECT (SUBJECT, SUBJECT_NAME, PULPIT)
    values ('ET', 'Ekonomicheskaya teoriya','ETiM');
insert into SUBJECT (SUBJECT, SUBJECT_NAME, PULPIT)
    values ('BLZiPsOO','Biologiya lesnyh zverey i ptits s osnovami ohotovedeniya','LV');
insert into SUBJECT (SUBJECT, SUBJECT_NAME, PULPIT)
    values ('OSPiLPH','Osnovy sadovo-parkovogo i lesoparkovogo hozyaystva', 'LPiSPS');
insert into SUBJECT (SUBJECT, SUBJECT_NAME,PULPIT)
    values ('IG', 'Inzhenernaya geodeziya ','LU');
insert into SUBJECT (SUBJECT, SUBJECT_NAME,PULPIT)
    values ('LV', 'Lesovodstvo', 'LZiDV'); 
insert into SUBJECT (SUBJECT, SUBJECT_NAME, PULPIT)
    values ('OH', 'Organicheskaya himiya', 'OH');   
insert into SUBJECT (SUBJECT, SUBJECT_NAME,PULPIT)
    values ('TRI', 'Tehnologiya rezinovyh izdeliy','TNViOH'); 
insert into SUBJECT (SUBJECT, SUBJECT_NAME, PULPIT)
    values ('VTL', 'Vodny transport lesa','TL');
insert into SUBJECT (SUBJECT, SUBJECT_NAME,PULPIT)
    values ('TiOL', 'Tehnologiya i oborudovanie lesozagotovok', 'LMiLZ'); 
insert into SUBJECT (SUBJECT, SUBJECT_NAME,PULPIT)
    values ('TOPI', 'Tehnologiya obogascheniya poleznyh iskopaemyh ','TNViOH');
insert into SUBJECT (SUBJECT, SUBJECT_NAME, PULPIT)
    values ('PEH', 'Prikladnaya elektrohimiya','PiAH');                                                                                                                                                           
  
------Создание и заполнение таблицы GROUPS
create table GROUPS 
(   IDGROUP  integer  identity(1,1) constraint GROUP_PK  primary key,              
    FACULTY   char(10) constraint GROUPS_FACULTY_FK foreign key         
                                                         references FACULTY(FACULTY), 
    PROFESSION  char(20) constraint GROUPS_PROFESSION_FK foreign key         
                                                         references PROFESSION(PROFESSION),
    YEAR_FIRST  smallint  check (YEAR_FIRST<=YEAR(GETDATE())),                  
)
insert into GROUPS (FACULTY, PROFESSION, YEAR_FIRST)
    values ('IT','1-40 01 02', 2013), --1
           ('IT','1-40 01 02', 2012),
           ('IT','1-40 01 02', 2011),
           ('IT','1-40 01 02', 2010),
           ('IT','1-47 01 01', 2013),---5 gr
           ('IT','1-47 01 01', 2012),
           ('IT','1-47 01 01', 2011),
           ('IT','1-36 06 01', 2010),-----8 gr
           ('IT','1-36 06 01', 2013),
           ('IT','1-36 06 01', 2012),
           ('IT','1-36 06 01', 2011),
           ('HTiT','1-36 01 08', 2013),---12 gr                                                  
           ('HTiT','1-36 01 08', 2012),
           ('HTiT','1-36 07 01', 2011),
           ('HTiT','1-36 07 01', 2010),
           ('TOV','1-48 01 02', 2012), ---16 gr 
           ('TOV','1-48 01 02', 2011),
           ('TOV','1-48 01 05', 2013),
           ('TOV','1-54 01 03', 2012),
           ('LXF','1-75 01 01', 2013),--20 gr      
           ('LXF','1-75 02 01', 2012),
           ('LXF','1-75 02 01', 2011),
           ('LXF','1-89 02 02', 2012),
           ('LXF','1-89 02 02', 2011),  
           ('TTLP','1-36 05 01', 2013),
           ('TTLP','1-36 05 01', 2012),
           ('TTLP','1-46 01 01', 2012),--27 gr
           ('IEF','1-25 01 07', 2013), 
           ('IEF','1-25 01 07', 2012),     
           ('IEF','1-25 01 07', 2010),
           ('IEF','1-25 01 08', 2013),
           ('IEF','1-25 01 08', 2012); ---32 gr       
                          
------Создание и заполнение таблицы STUDENT
create table STUDENT 
(    IDSTUDENT   integer  identity(1000,1) constraint STUDENT_PK  primary key,
     IDGROUP   integer  constraint STUDENT_GROUP_FK foreign key         
                      references GROUPS(IDGROUP),        
     NAME   nvarchar(100), 
     BDAY   date,
     STAMP  timestamp,
     INFO     xml,
     FOTO     varbinary
) 
insert into STUDENT (IDGROUP,NAME, BDAY)
    values (1, 'Silyuk Valeriya Ivanovna', '12.07.1994'),
           (1, 'Sergel Violeta Nikolaevna', '06.03.1994'),
           (1, 'Dobrodey Olga Anatolevna', '09.11.1994'),
           (1, 'Podolyak Mariya Sergeevna', '04.10.1994'),
           (1, 'Nikitenko Ekaterina Dmitrievna', '08.01.1994'),
           (2, 'Yatskevich Galina Iosifovna', '02.08.1993'),
           (2, 'Osadchaya Ela Vasilevna', '07.12.1993'),
           (2, 'Akulova Elena Gennadevna', '02.12.1993'),
           (3, 'Pleshkun Milana Anatolevna', '08.03.1992'),
           (3, 'Buyanova Mariya Aleksandrovna', '02.06.1992'),
           (3, 'Harchenko Elena Gennadevna', '11.12.1992'),
           (3, 'Kruchenok Evgeniy Aleksandrovich', '11.05.1992'),
           (3, 'Borohovsky Vitaliy Petrovich', '09.11.1992'),
           (3, 'Mackevich Nadezhda Valerevna', '01.11.1992'),
           (5, 'Loginova Mariya Vyacheslavovna', '08.07.1995'),
           (5, 'Belko Natalya Nikolaevna', '02.11.1995'),
           (5, 'Selilo Ekaterina Gennadevna', '07.05.1995'),
           (5, 'Drozd Anastasiya Andreevna', '04.08.1995'),
           (6, 'Kozlovskaya Elena Evgenevna', '08.11.1994'),
           (6, 'Potapnin Kirill Olegovich', '02.03.1994'),
           (6, 'Ravkovskaya Olga Nikolaevna', '04.06.1994'),
           (6, 'Hodoronok Aleksandra Vadimovna', '09.11.1994'),
           (6, 'Ramuk Vladislav Yurevich', '04.07.1994'),
           (7, 'Neruganenok Mariya Vladimirovna', '03.01.1993'),
           (7, 'Tsyganok Anna Petrovna', '12.09.1993'),
           (7, 'Masilevich Oksana Igorevna', '12.06.1993'),
           (7, 'Aleksievich Elizaveta Viktorovna','09.02.1993'),
           (7, 'Vatolin Maksim Andreevich', '04.07.1993'),
           (8, 'Sinica Valeriya Andreevna', '08.01.1992'),
           (8, 'Kudryashova Alina Nikolaevna', '12.05.1992'),
           (8, 'Migulina Elena Leonidovna', '08.11.1992'),
           (8, 'Shpilenya Aleksey Sergeevich', '12.03.1992'),
           (9, 'Astafev Igor Aleksandrovich', '10.08.1995'),
           (9, 'Gaytyukevich Andrey Igorevich', '02.05.1995'),
           (9, 'Ruchenya Natalya Aleksandrovna', '08.01.1995'),
           (9, 'Tarasevich Anastasiya Ivanovna', '11.09.1995'),
           (10, 'Zhoglin Nikolay Vladimirovich', '08.01.1994'),
           (10, 'Sanko Andrey Dmitrievich', '11.09.1994'),
           (10, 'Peshur Anna Aleksandrovna', '06.04.1994'),
           (10, 'Buchalis Nikita Leonidovich', '12.08.1994');

insert into STUDENT (IDGROUP,NAME, BDAY)
    values (11, 'Lavrenchuk Vladislav Nikolaevich','07.11.1993'),
           (11, 'Vlasik Evgeniya Viktorovna', '04.06.1993'),
           (11, 'Abramov Denis Dmitrievich', '10.12.1993'),
           (11, 'Olenchik Sergey Nikolaevich', '04.07.1993'),
           (11, 'Savinko Pavel Andreevich', '08.01.1993'),
           (11, 'Bakun Aleksey Viktorovich', '02.09.1993'),
           (12, 'Ban Sergey Anatolevich', '11.12.1995'),
           (12, 'Secheyko Ilya Aleksandrovich', '10.06.1995'),
           (12, 'Kuzmicheva Anna Andreevna', '09.08.1995'),
           (12, 'Burko Diana Frantsevna', '04.07.1995'),
           (12, 'Danilenko Maksim Vasilevich', '08.03.1995'),
           (12, 'Zizyuk Olga Olegovna', '12.09.1995'),
           (13, 'Sharapo Mariya Vladimirovna', '08.10.1994'),
           (13, 'Kasperovich Vadim Viktorovich', '10.02.1994'),
           (13, 'Chuprygin Arseniy Aleksandrovich','11.11.1994'),
           (13, 'Voevodskaya Olga Leonidovna', '10.02.1994'),
           (13, 'Metushevsky Denis Igorevich', '12.01.1994'),
           (14, 'Lovetskaya Valeriya Aleksandrovna','11.09.1993'),
           (14, 'Dvorak Antonina Nikolaevna', '01.12.1993'),
           (14, 'Schuka Tatyana Nikolaevna', '09.06.1993'),
           (14, 'Koblinec Aleksandra Evgenevna', '05.01.1993'),
           (14, 'Fomichevskaya Elena Ernestovna', '01.07.1993'),
           (15, 'Besarab Margarita Vadimovna', '07.04.1992'),
           (15, 'Baduro Viktoriya Sergeevna', '10.12.1992'),
           (15, 'Tarasenko Olga Viktorovna', '05.05.1992'),
           (15, 'Afanasenko Olga Vladimirovna', '11.01.1992'),
           (15, 'Chuykevich Irina Dmitrievna', '04.06.1992'),
           (16, 'Brel Alesya Alekseevna', '08.01.1994'),
           (16, 'Kuznecova Anastasiya Andreevna', '07.02.1994'),
           (16, 'Tomina Karina Gennadevna', '12.06.1994'),
           (16, 'Dubrova Pavel Igorevich', '03.07.1994'),
           (16, 'Shpakov Viktor Andreevich', '04.07.1994'),
           (17, 'Shneyder Anastasiya Dmitrievna', '08.11.1993'),
           (17, 'Shygina Elena Viktorovna', '02.04.1993'),
           (17, 'Klyueva Anna Ivanovna', '03.06.1993'),
           (17, 'Domorad Marina Andreevna', '05.11.1993'),
           (17, 'Linchuk Mihail Aleksandrovich', '03.07.1993'),
           (18, 'Vasileva Darya Olegovna', '08.01.1995'),
           (18, 'Schigelskaya Ekaterina Andreevna','06.09.1995'),
           (18, 'Sazonova Ekaterina Dmitrievna', '08.03.1995'),
           (18, 'Bakunovich Alina Olegovna', '07.08.1995');

------Создание и заполнение таблицы PROGRESS
create table PROGRESS
(  SUBJECT   char(10) constraint PROGRESS_SUBJECT_FK foreign key
                   references SUBJECT(SUBJECT),                
    IDSTUDENT integer  constraint PROGRESS_IDSTUDENT_FK foreign key         
                   references STUDENT(IDSTUDENT),        
    PDATE    date, 
    NOTE     integer check (NOTE between 1 and 10)
)
insert into PROGRESS (SUBJECT, IDSTUDENT, PDATE, NOTE)
    values ('OAiP', 1000, '01.10.2013',8),
           ('OAiP', 1001, '01.10.2013',7),
           ('OAiP', 1002, '01.10.2013',5),
           ('OAiP', 1004, '01.10.2013',4);
insert into PROGRESS (SUBJECT, IDSTUDENT, PDATE, NOTE)
    values ('SUBD', 1014, '01.12.2013',5),
           ('SUBD', 1015, '01.12.2013',9),
           ('SUBD', 1016, '01.12.2013',5),
           ('SUBD', 1017, '01.12.2013',4);
insert into PROGRESS (SUBJECT, IDSTUDENT, PDATE, NOTE)
    values ('KG', 1018, '06.05.2013',4),
           ('KG', 1019, '06.05.2013',7),
           ('KG', 1020, '06.05.2013',7),
           ('KG', 1021, '06.05.2013',9),
           ('KG', 1022, '06.05.2013',5),
           ('KG', 1023, '06.05.2013',6);