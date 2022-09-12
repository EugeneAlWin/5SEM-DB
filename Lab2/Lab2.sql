--Задание 1. Создайте табличное пространство для постоянных данных со следующими параметрами:
--- имя: TS_XXX;
--- имя файла: TS_XXX; 
--- начальный размер: 7М;
--- автоматическое приращение: 5М;
--- максимальный размер: 20М. 
CREATE TABLESPACE TS_GEV
    DATAFILE 'X:\Lab2\TS_GEV.dbf'
    SIZE 7M
    AUTOEXTEND ON NEXT 5M
    MAXSIZE 20M
    EXTENT MANAGEMENT LOCAL;
    
SELECT TABLESPACE_NAME, STATUS FROM SYS.DBA_TABLESPACES;

DROP TABLESPACE TS_GEV;

--Задание 2. Создайте табличное пространство для временных данных со следующими параметрами:
--?имя: TS_XXX_TEMP;
--?имя файла: TS_XXX_TEMP; 
--?начальный размер: 5М;
--?автоматическое приращение: 3М;
--?максимальный размер: 30М. 
 
 CREATE TEMPORARY TABLESPACE TS_TEMP_GEV
    TEMPFILE 'X:\Lab2\TS_TEMP_GEV.dbf'
    SIZE 5M
    AUTOEXTEND ON NEXT 3M
    MAXSIZE 20M
    EXTENT MANAGEMENT LOCAL;
    
--Задание 3. Получите список всех табличных пространств, списки всех файлов с помощью select-запроса к словарю.  
SELECT FILE_NAME, TABLESPACE_NAME FROM DBA_DATA_FILES
UNION
SELECT FILE_NAME, TABLESPACE_NAME FROM DBA_TEMP_FILES;

--Задание 4. Создайте роль с именем RL_XXXCORE. Назначьте ей следующие системные привилегии:
--?разрешение на соединение с сервером;
--?разрешение создавать и удалять таблицы, представления, процедуры и функции.

--alter session set "_ORACLE_SCRIPT"=true; 
CREATE ROLE RLGEVCORE;
SELECT * FROM dba_roles WHERE ROLE LIKE 'RL%';

GRANT CREATE SESSION,
    CREATE TABLE,
    CREATE VIEW,
    CREATE PROCEDURE TO RLGEVCORE;
    
GRANT DROP ANY TABLE, DROP ANY VIEW, DROP ANY PROCEDURE TO RLGEVCORE;

--Задание 5. Найдите с помощью select-запроса роль в словаре. 
--Найдите с помощью select-запроса все системные привилегии, назначенные роли. 

SELECT * FROM DBA_SYS_PRIVS WHERE GRANTEE = 'RLGEVCORE';  
SELECT * FROM DBA_SYS_PRIVS;

--Задание 6. Создайте профиль безопасности с именем PF_XXXCORE, имеющий опции, аналогичные примеру из лекции.
CREATE PROFILE PFGEVCORE LIMIT
    PASSWORD_LIFE_TIME 180
    SESSIONS_PER_USER 3
    FAILED_LOGIN_ATTEMPTS 7
    PASSWORD_LOCK_TIME 1
    PASSWORD_REUSE_TIME 10
    PASSWORD_GRACE_TIME DEFAULT
    CONNECT_TIME 180
    IDLE_TIME 30;


--Задание 7. Получите список всех профилей БД. Получите значения всех параметров профиля PF_XXXCORE.
--Получите значения всех параметров профиля DEFAULT.
SELECT * FROM DBA_PROFILES WHERE PROFILE = 'PFGEVCORE';
SELECT * FROM DBA_PROFILES;
SELECT * FROM DBA_PROFILES WHERE PROFILE = 'DEFAULT';

--Задание 8. Создайте пользователя с именем XXXCORE со следующими параметрами:
--- табличное пространство по умолчанию: TS_XXX;
--- табличное пространство для временных данных: TS_XXX_TEMP;
--- профиль безопасности PF_XXXCORE;
--- учетная запись разблокирована;
--- срок действия пароля истек. 

CREATE USER GEVCORE IDENTIFIED BY Pa$$word
    DEFAULT TABLESPACE TS_GEV QUOTA UNLIMITED ON TS_GEV
    TEMPORARY TABLESPACE TS_TEMP_GEV
    PROFILE PFGEVCORE
    ACCOUNT UNLOCK
    PASSWORD EXPIRE;

GRANT RLGEVCORE TO GEVCORE;

--Задание 11. Создайте табличное пространство с именем XXX_QDATA (10m). 
--При создании установите его в состояние offline. 
--Затем переведите табличное пространство в состояние online. 
--Выделите пользователю XXX квоту 2m в пространстве XXX_QDATA. 
--От имени пользователя XXX создайте таблицу в пространстве XXX_T1. 
--В таблицу добавьте 3 строки.

create tablespace GEV_QDATA
  datafile 'X:\Lab2\TS2_GEV.dbf'
  size 10m
  autoextend on next 5m
  maxsize 20m
  extent management local
  offline;

alter tablespace GEV_QDATA online;

alter user GEVCORE quota 2m on GEV_QDATA;
alter user GEVCORE default tablespace GEV_QDATA;

create table GEV_T1
  (x number(3), 
  y varchar(10));
  
insert into GEV_T1 values (1, 'one');
insert into GEV_T1 values (2, 'two');
insert into GEV_T1 values (3, 'three');

select * from GEV_T1;
