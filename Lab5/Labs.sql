--1
select * from dba_tablespaces;
--2
create tablespace GEV_QDATA_LAB5
  datafile 'C:\Tablespaces\GEV_QDATA_lab5.dbf'
  size 10 m
  autoextend on next 5 m
  maxsize 30 m
  extent management local
  offline;


GRANT CREATE SESSION,
      CREATE TABLE,
      CREATE VIEW,
      CREATE PROCEDURE TO U1_GEW_PDB;
alter tablespace GEV_QDATA_LAB5 online;  
--Drop tablespace GEV_QDATA
--ALTER SESSION SET "_ORACLE_SCRIPT"=true;  
--from PDM_PDB_admin
create table GEV_T1(
num int primary key,
desctiprion varchar(150))tablespace GEV_QDATA_LAB5;

insert into GEV_T1
  values (1, 'one');
insert into GEV_T1
  values (2, 'two');
insert into GEV_T1 
  values (3, 'three');
commit;

select * from GEV_T1;



alter user U1_GEW_PDB
  default tablespace GEV_QDATA_LAB5 quota 2m on GEV_QDATA_LAB5;

--3
select distinct * from user_segments where tablespace_name like 'GEV_QDATA_LAB5';
select distinct * from user_segments where tablespace_name != 'GEV_QDATA_LAB5';

--4
drop table GEV_T1;

select distinct * from user_segments where tablespace_name = 'GEV_QDATA_LAB5';

select * from dba_recyclebin;

--5
flashback table GEV_T1 to before drop;

--6
declare i int:= 4;
begin loop i:=i+1;
  Insert into GEV_T1 values (i,'number');
  exit when(i = 10000);
end loop;
end;  
select * from GEV_T1;

--7
select * from user_segments where tablespace_name = 'GEV_QDATA_LAB5';

select * from user_extents where tablespace_name = 'GEV_QDATA_LAB5';

--8
drop tablespace GEV_QDATA_LAB5 including contents and datafiles;
--9
select Group#,Status,Members from V$LOG;

--10
select * from V$LOGFILE;

--11
select * from V$LOG; -- 9:28 AM 10/10/2021

alter system switch logfile;
select GROUP#, SEQUENCE#,STATUS,FIRST_CHANGE#  From V$LOG;

--12
alter database add logfile group 4 'C:\app\ora_install_user\oradata\orcl\REDO04.LOG'
  size 50m blocksize 512;

select GROUP#, SEQUENCE#,STATUS,FIRST_CHANGE#  From V$LOG;

alter database add logfile member 'C:\app\ora_install_user\oradata\orcl\REDO041.LOG' to group 4;
alter database add logfile member 'C:\app\ora_install_user\oradata\orcl\REDO042.LOG' to group 4;
alter database add logfile member 'C:\app\ora_install_user\oradata\orcl\REDO043.LOG' to group 4;

--13
alter database drop logfile member 'C:\app\ora_install_user\oradata\orcl\REDO041.LOG';
alter database drop logfile member 'C:\app\ora_install_user\oradata\orcl\REDO042.LOG';
alter database drop logfile member 'C:\app\ora_install_user\oradata\orcl\REDO043.LOG';

alter database drop logfile group 4;

--14
select GROUP#, ARCHIVED from V$LOG;

select name, Log_MODE from v$database;
select Archiver, Active_State From v$instance;

--15
select * from (select * from v$archive_dest_status order by dest_id desc) 
  where rownum = 1;
--16
--Console
--SHUTDOWN IMMEDIATE;
--STARTUP MOUNT;
--ALTER DATABASE ARCHIVELOG;
--ALTER DATABASE OPEN;
--archive log list;

--17
alter system switch logfile;
select * from V$archived_log;

--18
--Console
--SHUTDOWN IMMEDIATE;
--STARTUP MOUNT;
--ALTER DATABASE NOARCHIVELOG;
--ALTER DATABASE OPEN;
--archive log list;

--19
select * from v$controlfile;

--20
select * from v$controlfile_record_section;
--21 C:\app\ora_install_user\product\12.1.0\dbhome_1\database
--22
create pfile = 'PDM_PFILE.ORA' from spfile;


--24
select * from v$diag_info;