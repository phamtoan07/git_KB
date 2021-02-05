--- Sử dụng user full quyền SYSTEM hoặc SYS...
--- Điền: ttusers (tên tablespace vừa tạo) khi được hỏi


SET FEEDBACK 1
SET NUMWIDTH 10
SET LINESIZE 80
SET TRIMSPOOL ON
SET TAB OFF
SET PAGESIZE 100

set serveroutput on;
set echo off;
set escape on;
drop role TT_CACHE_ADMIN_ROLE;
drop user TIMESTEN CASCADE;

SET SERVEROUTPUT ON;
PROMPT ;
PROMPT Please enter the tablespace where TIMESTEN user is to be created;
SET TERMOUT OFF;
SET VERIFY OFF;
DEFINE adminIdPr = '&&1';
SET TERMOUT ON;
PROMPT The value chosen for tablespace is &1;
PROMPT ;

DECLARE
tableSpaceName VARCHAR2(30) := '&&1';
countGridId int;        
timestenuserexists NUMBER := -1;
timestenroleexists NUMBER := -1;
gridinfoexists     NUMBER := -1;
grididexists       NUMBER := -1;  
error NUMBER := 0;
	  
PROCEDURE executeString (str in VARCHAR2, errToIgnore NUMBER) is err NUMBER;
BEGIN
	EXECUTE IMMEDIATE str;
EXCEPTION
  WHEN OTHERS THEN
    err := SQLCODE;
    IF(err != errToIgnore) THEN 
	  DBMS_OUTPUT.PUT_LINE(SQLERRM);
	  error := err;
    END IF;
END;

   
BEGIN

	-- Check if the TIMESTEN user and TT_CACHE_ADMIN_ROLE exist

	EXECUTE IMMEDIATE 'select count(*) from all_users where username = ''TIMESTEN''' into timestenuserexists;

	EXECUTE IMMEDIATE 'select count(*) from dba_roles where role = ''TT_CACHE_ADMIN_ROLE''' into timestenroleexists;

	EXECUTE IMMEDIATE 'select count(*) from all_objects where object_name = ''TT_GRIDINFO'' and owner = ''TIMESTEN''' into gridinfoexists;

	EXECUTE IMMEDIATE 'select count(*) from all_objects where object_name = ''TT_GRIDID'' and owner = ''TIMESTEN''' into grididexists;

	IF (timestenroleexists = 1) THEN
		IF (timestenuserexists = 0) THEN
			DBMS_OUTPUT.NEW_LINE;
			DBMS_OUTPUT.PUT_LINE('TIMESTEN schema does not exist. But TT_CACHE_ADMIN_ROLE role already exists. Please drop this role before this script is re-run');
		ELSE
			DBMS_OUTPUT.NEW_LINE;
			DBMS_OUTPUT.PUT_LINE('TIMESTEN schema and TT_CACHE_ADMIN_ROLE role already exist ');

			IF (grididexists = 0) THEN
				executeString('CREATE TABLE timesten.TT_GRIDID(gridIdNum int NOT NULL, comment_t varchar2(4000))', -955);
			END IF;
			
			IF (gridinfoexists = 0) THEN   
				executeString('CREATE TABLE timesten.TT_GRIDINFO(gridName varchar2(30), gridIdNum int NOT NULL, cacheAdminId varchar2(30) NOT NULL, comment_t varchar2(4000))', -955);
			END IF;

			-- Check if there is a row in the TIMESTEN.TT_GRIDID table   
			countGridId := 0;      
			execute immediate 'select count(*) from TIMESTEN.TT_GRIDID' into countGridId;
			IF (countGridId = 0) THEN
			   executeString('INSERT INTO timesten.tt_gridid (gridIdNum, comment_t) VALUES (0, ''Initial value for gridId'')', -1);
			END IF;
		END IF;
	ELSE
		IF (timestenuserexists = 1) THEN
			DBMS_OUTPUT.NEW_LINE;
			DBMS_OUTPUT.PUT_LINE('TIMESTEN schema exists. But TT_CACHE_ADMIN_ROLE role does not exist. This script will create the role and preserve the existing TIMESTEN schema');
			DBMS_OUTPUT.NEW_LINE;
			IF (grididexists = 0) THEN
				executeString('CREATE TABLE timesten.TT_GRIDID(gridIdNum int NOT NULL, comment_t varchar2(4000))', -955);
			END IF;
			
			IF (gridinfoexists = 0) THEN   
				executeString('CREATE TABLE timesten.TT_GRIDINFO(gridName varchar2(30), gridIdNum int NOT NULL, cacheAdminId varchar2(30) NOT NULL, comment_t varchar2(4000))', -955);
			END IF;

			-- Check if there is a row in the TIMESTEN.TT_GRIDID table   
			countGridId := 0;      
			execute immediate 'select count(*) from TIMESTEN.TT_GRIDID' into countGridId;
				IF (countGridId = 0) THEN
					executeString('INSERT INTO timesten.tt_gridid (gridIdNum, comment_t) VALUES (0, ''Initial value for gridId'')', -1);
				END IF;
			DBMS_OUTPUT.NEW_LINE;
			DBMS_OUTPUT.PUT_LINE('***************** Creation of TT_CACHE_ADMIN_ROLE starts ******************');
			executeString('CREATE USER timesten IDENTIFIED BY timesten  DEFAULT TABLESPACE ' || tableSpaceName || ' quota 5M ON ' || tableSpaceName || ' account LOCK', -1920);
			-- Now create the TT_GRIDID table 
			executeString('CREATE TABLE timesten.TT_GRIDID(gridIdNum int NOT NULL, comment_t varchar2(4000))', -955); 

			-- Now create the TT_GRIDINFO table 
			executeString('CREATE TABLE timesten.TT_GRIDINFO(gridName varchar2(30), gridIdNum int NOT NULL, cacheAdminId varchar2(30) NOT NULL, comment_t varchar2(4000))', -955);

			-- Check if there is a row in the TIMESTEN.TT_GRIDID table   
			countGridId := 0;
			execute immediate 'select count(*) from TIMESTEN.TT_GRIDID' into countGridId;
			--If the count is 0, insert a row
			IF (countGridId = 0) THEN
			   -- insert the first row
			   executeString('INSERT INTO timesten.tt_gridid (gridIdNum, comment_t) VALUES (0, ''Initial value for gridId'')', -1);
			END IF;
			-- Now create the TT_CACHE_ADMIN_ROLE   
			DBMS_OUTPUT.NEW_LINE;
			DBMS_OUTPUT.PUT_LINE('1. Creating TT_CACHE_ADMIN_ROLE role');
			executeString('CREATE ROLE tt_cache_admin_role', -1921);
			   
			-- Grant the updates on the TT_GRIDID and TT_GRIDINFO tables  

			executeString('GRANT UPDATE, SELECT ON timesten.TT_GRIDID TO tt_cache_admin_role', -1919);    
			DBMS_OUTPUT.NEW_LINE;
			DBMS_OUTPUT.PUT_LINE('2. Granting privileges to TT_CACHE_ADMIN_ROLE');
			executeString('GRANT INSERT, DELETE, UPDATE, SELECT ON timesten.TT_GRIDINFO TO tt_cache_admin_role', -1919);
		ELSE

			DBMS_OUTPUT.NEW_LINE;
			DBMS_OUTPUT.PUT_LINE('******* Creation of TIMESTEN schema and TT_CACHE_ADMIN_ROLE starts *******');

			-- Try  and create the TIMESTEN user first
			DBMS_OUTPUT.NEW_LINE;
			DBMS_OUTPUT.PUT_LINE('1. Creating TIMESTEN schema');

			executeString('CREATE USER timesten IDENTIFIED BY timesten  DEFAULT TABLESPACE ' || tableSpaceName || ' quota 5M ON ' || tableSpaceName || ' account LOCK', -1920);

			-- Now create the TT_GRIDID table 
			DBMS_OUTPUT.NEW_LINE;
			DBMS_OUTPUT.PUT_LINE('2. Creating TIMESTEN.TT_GRIDID table');
			executeString('CREATE TABLE timesten.TT_GRIDID(gridIdNum int NOT NULL, comment_t varchar2(4000))', -955); 

			-- Now create the TT_GRIDINFO table 
			DBMS_OUTPUT.NEW_LINE;
			DBMS_OUTPUT.PUT_LINE('3. Creating TIMESTEN.TT_GRIDINFO table');   
			executeString('CREATE TABLE timesten.TT_GRIDINFO(gridName varchar2(30), gridIdNum int NOT NULL, cacheAdminId varchar2(30) NOT NULL, comment_t varchar2(4000))', -955);

			-- Check if there is a row in the TIMESTEN.TT_GRIDID table   
			countGridId := 0;
			execute immediate 'select count(*) from TIMESTEN.TT_GRIDID' into countGridId;

			--If the count is 0, insert a row
			IF (countGridId = 0) THEN
			   -- insert the first row
				executeString('INSERT INTO timesten.tt_gridid (gridIdNum, comment_t) VALUES (0, ''Initial value for gridId'')', -1);
			END IF;

			-- Now create the TT_CACHE_ADMIN_ROLE   
			DBMS_OUTPUT.NEW_LINE;
			DBMS_OUTPUT.PUT_LINE('4. Creating TT_CACHE_ADMIN_ROLE role');
			executeString('CREATE ROLE tt_cache_admin_role', -1921);
			   
			-- Grant the updates on the TT_GRIDID and TT_GRIDINFO tables  

			executeString('GRANT UPDATE, SELECT ON timesten.TT_GRIDID TO tt_cache_admin_role', -1919);    
			DBMS_OUTPUT.NEW_LINE;
			DBMS_OUTPUT.PUT_LINE('5. Granting privileges to TT_CACHE_ADMIN_ROLE');
			executeString('GRANT INSERT, DELETE, UPDATE, SELECT ON timesten.TT_GRIDINFO TO tt_cache_admin_role', -1919);
		END IF;

		IF (error = 0) THEN
		   DBMS_OUTPUT.NEW_LINE;
		   DBMS_OUTPUT.PUT_LINE('** Creation of TIMESTEN schema and TT_CACHE_ADMIN_ROLE done successfully **');
		   DBMS_OUTPUT.NEW_LINE;
		ELSE
		   DBMS_OUTPUT.NEW_LINE;
		   DBMS_OUTPUT.PUT_LINE('** Creation of TIMESTEN schema and TT_CACHE_ADMIN_ROLE not successfully done **');
		   DBMS_OUTPUT.NEW_LINE;
		END IF;
	END IF;

END;

/
undefine 1;