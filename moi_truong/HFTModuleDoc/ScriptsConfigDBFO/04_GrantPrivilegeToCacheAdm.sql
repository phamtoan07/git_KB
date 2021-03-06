--- Sử dụng user full quyền SYSTEM hoặc SYS...
--- Điền: 'cacheadm' (tên Cache Admin User vừa tạo) khi được hỏi


SET ECHO OFF
SET FEEDBACK 0
SET NUMWIDTH 10
SET LINESIZE 80
SET TRIMSPOOL ON
SET TAB OFF
SET PAGESIZE 100

SET SERVEROUTPUT ON;
PROMPT ;
PROMPT Please enter the administrator user id;
SET TERMOUT OFF;
SET VERIFY OFF;
DEFINE adminIdPr = '&&1';
SET TERMOUT ON;
PROMPT The value chosen for administrator user id is &1;
PROMPT ;


DECLARE
adminId VARCHAR2(30) := '&1';
ttprefix VARCHAR2(30) := 'TT_06_';
tableSpaceForTimesTenUser VARCHAR2(30);
timestenuserexists NUMBER := -1;
timestenroleexists NUMBER := -1;
tablespaceexists   NUMBER := -1;
admintablespace    VARCHAR2(30);
error NUMBER := 0;
counter NUMBER := 0; 
PROCEDURE executeString (str in VARCHAR2, errToIgnore NUMBER) is err NUMBER;
BEGIN
	EXECUTE IMMEDIATE str;
EXCEPTION WHEN OTHERS THEN
	err := SQLCODE;
	IF(err != errToIgnore) THEN 
		DBMS_OUTPUT.PUT_LINE(SQLERRM );
		error := 1;
	END IF;
END;

BEGIN
	EXECUTE IMMEDIATE 'select count(*) from all_users where username = ''TIMESTEN''' into timestenuserexists;

	EXECUTE IMMEDIATE 'select count(*) from dba_roles where role = ''TT_CACHE_ADMIN_ROLE''' into timestenroleexists;

	IF (timestenuserexists = 0 OR timestenroleexists = 0) THEN
		DBMS_OUTPUT.PUT_LINE(chr(1));
		DBMS_OUTPUT.PUT_LINE(chr (5) || '    TIMESTEN schema needs to be created before this script is run');
		DBMS_OUTPUT.PUT_LINE(chr (5) || '    Please run initCacheGlobalSchema.sql first');
	ELSE

		DBMS_OUTPUT.NEW_LINE;
		DBMS_OUTPUT.PUT_LINE('***************** Initialization for cache admin begins ******************');

		--------------- Granting the CREATE SESSION to the admin -------

		DBMS_OUTPUT.NEW_LINE;
		DBMS_OUTPUT.PUT_LINE(counter||'. Granting the CREATE SESSION privilege to ' || UPPER('cacheadm'));
		executeString('GRANT CREATE SESSION TO ' || 'cacheadm', -1919);
		counter := counter + 1;

		--------------- Granting the tt_cache_admin_role to the admin -------

		DBMS_OUTPUT.NEW_LINE;
		DBMS_OUTPUT.PUT_LINE(counter||'. Granting the TT_CACHE_ADMIN_ROLE to ' || UPPER('cacheadm'));
		executeString('GRANT tt_cache_admin_role TO ' || 'cacheadm', -1919);
		counter := counter + 1;

		--------------- Granting execute privilege on DBMS_LOCK package to the admin -------

		DBMS_OUTPUT.NEW_LINE;
		DBMS_OUTPUT.PUT_LINE(counter||'. Granting the DBMS_LOCK package privilege to ' || UPPER('cacheadm'));
		executeString('GRANT EXECUTE ON SYS.DBMS_LOCK TO ' || 'cacheadm', -1919);
		counter := counter + 1;

		--------------- Granting the CREATE RESOURCE to the admin -------

		DBMS_OUTPUT.NEW_LINE;
		DBMS_OUTPUT.PUT_LINE(counter||'. Granting the RESOURCE  privilege to ' || UPPER('cacheadm'));
		executeString('GRANT RESOURCE TO ' || 'cacheadm', -1919);
		counter := counter + 1;


		--------------- Granting the CREATE PROCEDURE to the admin -------

		DBMS_OUTPUT.NEW_LINE;
		DBMS_OUTPUT.PUT_LINE(counter||'. Granting the CREATE PROCEDURE  privilege to ' || UPPER('cacheadm'));
		executeString('GRANT CREATE PROCEDURE TO ' || 'cacheadm', -1919);
		counter := counter + 1;


		--------------- Granting the CREATE ANY TRIGGER to the admin -------

		DBMS_OUTPUT.NEW_LINE;
		DBMS_OUTPUT.PUT_LINE(counter||'. Granting the CREATE ANY TRIGGER  privilege to ' || UPPER('cacheadm'));
		executeString('GRANT CREATE ANY TRIGGER TO ' || 'cacheadm', -1919);
		counter := counter + 1;

		--------------- Granting the EXECUTE DBMS_LOB to the admin -------

		DBMS_OUTPUT.NEW_LINE;
		DBMS_OUTPUT.PUT_LINE(counter||'. Granting the DBMS_LOB package privilege to ' || UPPER('cacheadm'));
		executeString('GRANT EXECUTE ON SYS.DBMS_LOB TO ' || 'cacheadm', -1919);
		counter := counter + 1;

		--------------- Granting the SELECT ON ALL_OBJECTS to the admin -------

		DBMS_OUTPUT.NEW_LINE;
		DBMS_OUTPUT.PUT_LINE(counter||'. Granting the SELECT on SYS.ALL_OBJECTS privilege to ' || UPPER('cacheadm'));
		executeString('GRANT SELECT ON SYS.ALL_OBJECTS TO ' || 'cacheadm', -1919);
		counter := counter + 1;

		--------------- Granting the SELECT ON ALL_SYNONYMS to the admin -------

		DBMS_OUTPUT.NEW_LINE;
		DBMS_OUTPUT.PUT_LINE(counter||'. Granting the SELECT on SYS.ALL_SYNONYMS privilege to ' || UPPER('cacheadm'));
		executeString('GRANT SELECT ON SYS.ALL_SYNONYMS TO ' || 'cacheadm', -1919);
		counter := counter + 1;


		DBMS_OUTPUT.NEW_LINE;
		DBMS_OUTPUT.PUT_LINE(counter||'. Checking if the cache administrator user has permissions on the default tablespace ');
		counter := counter + 1;

		EXECUTE IMMEDIATE 'SELECT count(*) FROM dba_ts_quotas ts, dba_users users WHERE ts.tablespace_name = users.default_tablespace and users.username= ''' || UPPER('cacheadm') || '''and ts.username=users.username' INTO tablespaceexists;

		EXECUTE IMMEDIATE 'SELECT default_tablespace FROM dba_users users WHERE username= ''' || UPPER('cacheadm') || ''' ' INTO admintablespace;

		IF (tablespaceexists = 0)  THEN
		   DBMS_OUTPUT.PUT_LINE(chr (7) || '     No existing permission.');
		   DBMS_OUTPUT.NEW_LINE;   
		   DBMS_OUTPUT.PUT_LINE(counter||'. Altering the cache administrator to grant unlimited tablespace on ' || admintablespace);
		   executeString('ALTER USER ' || UPPER ('cacheadm') || ' QUOTA UNLIMITED ON ' || admintablespace, 1031);  
		ELSE
		   DBMS_OUTPUT.PUT_LINE(chr (7) || '     Permission exists');
		END iF;
		
		counter := counter + 1;

		DBMS_OUTPUT.NEW_LINE;
		DBMS_OUTPUT.PUT_LINE(counter || '. Granting the CREATE TYPE privilege to ' || UPPER('cacheadm'));
		executeString('GRANT CREATE TYPE TO ' || 'cacheadm', -1919);
		counter := counter + 1;

		  
		--------------- Granting the SELECT ON GV$LOCK to the admin -------
		   
		DBMS_OUTPUT.NEW_LINE;
		DBMS_OUTPUT.PUT_LINE(counter||'. Granting the SELECT on SYS.GV$LOCK privilege to ' || UPPER('cacheadm') || ' (optional) ');
		executeString('GRANT SELECT ON SYS.GV_$LOCK TO ' || 'cacheadm', -1919);
		counter := counter + 1;

		--------------- Granting the SELECT ON GV$SESSION to the admin -------

		DBMS_OUTPUT.NEW_LINE;
		DBMS_OUTPUT.PUT_LINE(counter||'. Granting the SELECT on SYS.GV$SESSION privilege  to ' || UPPER('cacheadm') || ' (optional) ');
		executeString('GRANT SELECT ON SYS.GV_$SESSION TO ' || 'cacheadm', -1919);
		counter := counter + 1;


		--------------- Granting the SELECT ON SYS.DBA_DATA_FILES to the admin -------

		DBMS_OUTPUT.NEW_LINE;
		DBMS_OUTPUT.PUT_LINE(counter||'. Granting the SELECT on SYS.DBA_DATA_FILES privilege  to ' || UPPER('cacheadm') || ' (optional) ');
		executeString('GRANT SELECT ON SYS.DBA_DATA_FILES TO ' || 'cacheadm', -1919);
		counter := counter + 1;


		--------------- Granting the SELECT ON SYS.USER_USERS to the admin -------

		DBMS_OUTPUT.NEW_LINE;
		DBMS_OUTPUT.PUT_LINE(counter||'. Granting the SELECT on SYS.USER_USERS privilege  to ' || UPPER('cacheadm') || ' (optional) ');
		executeString('GRANT SELECT ON SYS.USER_USERS TO ' || 'cacheadm', -1919);
		counter := counter + 1;

		--------------- Granting the SELECT ON SYS.USER_FREE_SPACE to the admin -------

		DBMS_OUTPUT.NEW_LINE;
		DBMS_OUTPUT.PUT_LINE(counter||'. Granting the SELECT on SYS.USER_FREE_SPACE privilege  to ' || UPPER('cacheadm') || ' (optional) ');
		executeString('GRANT SELECT ON SYS.USER_FREE_SPACE TO ' || 'cacheadm', -1919);
		counter := counter + 1;


		--------------- Granting the SELECT ON SYS.USER_TS_QUOTAS to the admin -------

		DBMS_OUTPUT.NEW_LINE;
		DBMS_OUTPUT.PUT_LINE(counter||'. Granting the SELECT on SYS.USER_TS_QUOTAS privilege  to ' || UPPER('cacheadm') || ' (optional) ');
		executeString('GRANT SELECT ON SYS.USER_TS_QUOTAS TO ' || 'cacheadm', -1919);
		counter := counter + 1;


		--------------- Granting the SELECT ON SYS.USER_SYS_PRIVS to the admin -------

		DBMS_OUTPUT.NEW_LINE;
		DBMS_OUTPUT.PUT_LINE(counter||'. Granting the SELECT on SYS.USER_SYS_PRIVS privilege  to ' || UPPER('cacheadm') || ' (optional) ');
		executeString('GRANT SELECT ON SYS.USER_SYS_PRIVS TO ' || 'cacheadm', -1919);
		counter := counter + 1;

		IF (error = 0) THEN
		   DBMS_OUTPUT.NEW_LINE;
		   DBMS_OUTPUT.PUT_LINE('********* Initialization for cache admin user done successfully *********');
		   DBMS_OUTPUT.NEW_LINE;
		ELSE
		   DBMS_OUTPUT.NEW_LINE;
		   DBMS_OUTPUT.PUT_LINE('** Initialization for cache admin user could not be successfully done  **');
		   DBMS_OUTPUT.NEW_LINE;
		END IF;
	END IF;
END;
/

undefine 1;