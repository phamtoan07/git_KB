SELECT any_path FROM resource_view WHERE any_path like '/sys/acls/%.xml';
---
BEGIN 
DBMS_NETWORK_ACL_ADMIN.CREATE_ACL(
  acl => 'www.xml', 
  description => 'WWW ACL', 
  principal   => 'HOSTKBSVT', 
  is_grant    => true, 
  privilege   => 'connect');
DBMS_NETWORK_ACL_ADMIN.ADD_PRIVILEGE(
  acl => 'www.xml', 
  principal => 'HOSTKBSVT', 
  is_grant  => true, 
  privilege => 'resolve');
DBMS_NETWORK_ACL_ADMIN.ADD_PRIVILEGE(
  acl => 'www.xml', 
  principal => 'HOSTKBSVT', 
  is_grant  => true, 
  privilege => 'connect'); 
END;

BEGIN
DBMS_NETWORK_ACL_ADMIN.ASSIGN_ACL(acl  => 'www.xml',
 host => '192.168.1.203'); 
END;
---
SELECT host, lower_port, upper_port, acl,
     DECODE(
         DBMS_NETWORK_ACL_ADMIN.CHECK_PRIVILEGE_ACLID(aclid, 'HOSTKBSVD', 'connect'),
            1, 'GRANTED', 0, 'DENIED', null) privilege
     FROM dba_network_acls
    WHERE host IN
      (SELECT * FROM
         TABLE(DBMS_NETWORK_ACL_UTILITY.DOMAINS('192.168.1.203')))  
