REM
REM Create a application user fo for running the FSS programs 
REM

CREATE USER fopro IDENTIFIED BY fopro;
GRANT XLA, CREATE SESSION TO fopro;
GRANT CREATE TABLE, CREATE SEQUENCE, CREATE PROCEDURE TO fopro;
GRANT CREATE SYNONYM TO fopro;
GRANT CREATE PUBLIC SYNONYM TO fopro;
GRANT CACHE_MANAGER, CREATE ANY TABLE TO fopro;
GRANT ADMIN TO fopro;
DEFINE back_password=fopro ;

REM
REM Return all database users in the FSS FRONT database
REM

SELECT username, user_id, TO_CHAR(created,'YYYY-MM-DD HH24:MI:SS') 
FROM   sys.all_users;
PROMPT

REM
REM Return the system privileges assigned to each user
REM

SELECT * FROM sys.dba_sys_privs;

REM select * from indexes where ixowner = 'fopro';
