--������� 1. �������� ��������� ������������ ��� ���������� ������ �� ���������� �����������:
--- ���: TS_XXX;
--- ��� �����: TS_XXX; 
--- ��������� ������: 7�;
--- �������������� ����������: 5�;
--- ������������ ������: 20�. 
CREATE TABLESPACE TS_GEV
    DATAFILE 'X:\Lab2\TS_GEV.dbf'
    SIZE 7M
    AUTOEXTEND ON NEXT 5M
    MAXSIZE 20M
    EXTENT MANAGEMENT LOCAL;
    
SELECT TABLESPACE_NAME, STATUS FROM SYS.DBA_TABLESPACES;

DROP TABLESPACE TS_GEV;

--������� 2. �������� ��������� ������������ ��� ��������� ������ �� ���������� �����������:
--?���: TS_XXX_TEMP;
--?��� �����: TS_XXX_TEMP; 
--?��������� ������: 5�;
--?�������������� ����������: 3�;
--?������������ ������: 30�. 
 
 CREATE TEMPORARY TABLESPACE TS_TEMP_GEV
    TEMPFILE 'X:\Lab2\TS_TEMP_GEV.dbf'
    SIZE 5M
    AUTOEXTEND ON NEXT 3M
    MAXSIZE 20M
    EXTENT MANAGEMENT LOCAL;
    
--������� 3. �������� ������ ���� ��������� �����������, ������ ���� ������ � ������� select-������� � �������.  
SELECT FILE_NAME, TABLESPACE_NAME FROM DBA_DATA_FILES
UNION
SELECT FILE_NAME, TABLESPACE_NAME FROM DBA_TEMP_FILES;

--������� 4. �������� ���� � ������ RL_XXXCORE. ��������� �� ��������� ��������� ����������:
--?���������� �� ���������� � ��������;
--?���������� ��������� � ������� �������, �������������, ��������� � �������.

--alter session set "_ORACLE_SCRIPT"=true; 
CREATE ROLE RLGEVCORE;
SELECT * FROM dba_roles WHERE ROLE LIKE 'RL%';

GRANT CREATE SESSION,
    CREATE TABLE,
    CREATE VIEW,
    CREATE PROCEDURE TO RLGEVCORE;
    
GRANT DROP ANY TABLE, DROP ANY VIEW, DROP ANY PROCEDURE TO RLGEVCORE;

--������� 5. ������� � ������� select-������� ���� � �������. 
--������� � ������� select-������� ��� ��������� ����������, ����������� ����. 

SELECT * FROM DBA_SYS_PRIVS WHERE GRANTEE = 'RLGEVCORE';  
SELECT * FROM DBA_SYS_PRIVS;

--������� 6. �������� ������� ������������ � ������ PF_XXXCORE, ������� �����, ����������� ������� �� ������.
CREATE PROFILE PFGEVCORE LIMIT
    PASSWORD_LIFE_TIME 180
    SESSIONS_PER_USER 3
    FAILED_LOGIN_ATTEMPTS 7
    PASSWORD_LOCK_TIME 1
    PASSWORD_REUSE_TIME 10
    PASSWORD_GRACE_TIME DEFAULT
    CONNECT_TIME 180
    IDLE_TIME 30;


--������� 7. �������� ������ ���� �������� ��. �������� �������� ���� ���������� ������� PF_XXXCORE.
--�������� �������� ���� ���������� ������� DEFAULT.
SELECT * FROM DBA_PROFILES WHERE PROFILE = 'PFGEVCORE';
SELECT * FROM DBA_PROFILES;
SELECT * FROM DBA_PROFILES WHERE PROFILE = 'DEFAULT';

--������� 8. �������� ������������ � ������ XXXCORE �� ���������� �����������:
--- ��������� ������������ �� ���������: TS_XXX;
--- ��������� ������������ ��� ��������� ������: TS_XXX_TEMP;
--- ������� ������������ PF_XXXCORE;
--- ������� ������ ��������������;
--- ���� �������� ������ �����. 

CREATE USER GEVCORE IDENTIFIED BY Pa$$word
    DEFAULT TABLESPACE TS_GEV QUOTA UNLIMITED ON TS_GEV
    TEMPORARY TABLESPACE TS_TEMP_GEV
    PROFILE PFGEVCORE
    ACCOUNT UNLOCK
    PASSWORD EXPIRE;

GRANT RLGEVCORE TO GEVCORE;

--������� 11. �������� ��������� ������������ � ������ XXX_QDATA (10m). 
--��� �������� ���������� ��� � ��������� offline. 
--����� ���������� ��������� ������������ � ��������� online. 
--�������� ������������ XXX ����� 2m � ������������ XXX_QDATA. 
--�� ����� ������������ XXX �������� ������� � ������������ XXX_T1. 
--� ������� �������� 3 ������.

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
