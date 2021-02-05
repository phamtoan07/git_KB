--- Sử dụng user full quyền SYSTEM hoặc SYS...

--- Tạo cache user admin trên DB Persit
drop user cacheadm CASCADE;
create user cacheadm identified by cacheadm
	default tablespace ttusers
	quota unlimited on ttusers
	temporary tablespace temp;
GRANT create session to cacheadm;
